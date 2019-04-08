function [ CVStat, CVTime, CVRate ] = SSR_DMTSVM( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_QUAD_SOLVER 此处显示有关此函数的摘要
% Safe Screening for DMTSVM
%   此处显示详细说明

%% Fit
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 4);
for i = 1 : n
    Params = GetParams(IParams, i);
    tic;
    [ H3, H4, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, Params);
    C1 = Params.C1;
    if i > 1
        C0 = LastParams.C1;
        % solve the rest problem
        [ bC, bMP ] = EqualsTo(Params, LastParams);
        if bC
            [ Alpha1 ] = SSR_C(H3, Alpha0, C1, C0);
            [ Gamma1 ] = SSR_C(H4, Gamma0, C1, C0);
            [ CVRate(i,1:2) ] = GetRate([ Alpha1; Gamma1 ], C1);
            [ Alpha0 ] = Reduced(H3, Alpha1, C1);
            [ Gamma0 ] = Reduced(H4, Gamma1, C1);
        elseif bMP
            [ Alpha1 ] = SSR_MU_P(H1, H3, Alpha0, C1);
            [ Gamma1 ] = SSR_MU_P(H2, H4, Gamma0, C1);
            [ CVRate(i,1:2) ] = GetRate([ Alpha1; Gamma1 ], C1);
            [ Alpha0 ] = Reduced(H3, Alpha1, C1);
            [ Gamma0 ] = Reduced(H4, Gamma1, C1);
        else
            % solve the first problem
            [ Alpha0 ] = Primal(H3, -e2, zeros(m2, 1), C1*e2);
            [ Gamma0 ] = Primal(H4, -e1, zeros(m1, 1), C1*e1);
        end
    else
        % solve the first problem
        [ Alpha0 ] = Primal(H3, -e2, zeros(m2, 1), C1*e2);
        [ Gamma0 ] = Primal(H4, -e1, zeros(m1, 1), C1*e1);
    end
    H1 = H3; H2 = H4;
    [ CVTime(i, 1) ] = toc;
    % 预测
    [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha0, Gamma0, N, TaskNum, Params);
    [ y_hat ] = Predict(xTest, X, TaskNum, U, V, Params);
    [ CVRate(i,3:4) ] = GetTotalRate([ Alpha0; Gamma0 ], C1);
    [ CVStat(i,:,:) ] = MTLStatistics(TaskNum, y_hat, yTest, opts);
    LastParams = Params;
end

    function [ bC, bMP ] = EqualsTo(p1, p2)
        k1 = p1.kernel;
        k2 = p2.kernel;
        if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
            bC = k1.p1 == k2.p1 && p1.rho == p2.rho;
            bM = k1.p1 == k2.p1 && p1.C1 == p2.C1;
            bP = p1.C1 == p2.C1 && p1.rho == p2.rho;
            bMP = bM || bP;
        else
            bC = p1.rho == p2.rho;
            bMP = p1.C1 == p2.C1;
        end
    end

    function [ H1, H2, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, opts)
        % 分割正负类点
        A = X(Y==1,:);
        B = X(Y==-1,:);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        % 核函数
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        E = [Kernel(A, X, opts.kernel) e1];
        F = [Kernel(B, X, opts.kernel) e2];
        % 得到Q,R矩阵
        EE = Cond(E'*E); FF = Cond(F'*F);
        EEF = EE\F'; FFE = FF\E';
        Q = F*EEF; R = E*FFE;
        % 得到P,S矩阵
        Ec = mat2cell(E, N(1,:));
        Fc = mat2cell(F, N(2,:));
        EEc = mat2cell(EE, N(1,:), N(1,:));
        FFc = mat2cell(FF, N(2,:), N(2,:));
        EEFc = cell(TaskNum, 1);
        FFEc = cell(TaskNum, 1);
        P = sparse(0, 0);
        S = sparse(0, 0);
        for t = 1 : TaskNum
            EEFc{t} = EEc{t,t}\(Fc{t}');
            FFEc{t} = FFc{t,t}\(Ec{t}');
            P = blkdiag(P, Fc{t}*EEFc{t});
            S = blkdiag(S, Ec{t}*FFEc{t});
        end
        H1 = Cond(Q + 1/opts.rho*P);
        H2 = Cond(R + 1/opts.rho*S);
    end

    function [ Alpha ] = Primal(H, f, lb, ub)
        Alpha = quadprog(H,f,[],[],[],[],lb,ub,[],[]);
    end

    function [ Alpha ] = Reduced(H, Alpha, C1)
        % reduced problem
        [ ~, R, S ] = GetRate(Alpha, C1);
        if mean(R) > 0
            f = H(R,S)*Alpha(S)-1;
            lb = zeros(size(f));
            ub = C1*ones(size(f));
            Alpha(R) = quadprog(H(R,R),f,[],[],[],[],lb,ub,[],[]);
        end
    end

    function [ Rate ] = GetTotalRate(Alpha, C1)
        Rate = mean([abs(Alpha)<1e-7, abs(Alpha-C1)<1e-7]);
    end

    function [ Rate, R, S ] = GetRate(Alpha, C1)
        R = Alpha == Inf;
        S0 = Alpha == 0;
        SC = Alpha == C1;
        S = S0 | SC;
        Rate = mean([S0, SC]);
    end

    function [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha, Gamma, N, TaskNum, opts)
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = u - EEFc{t}*(1/opts.rho*CAlpha{t});
            V{t} = v + FFEc{t}*(1/opts.rho*CGamma{t});
        end
    end

    function [ yTest ] = Predict(xTest, X, TaskNum, U, V, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            At = xTest{t};
            [m, ~] = size(At);
            et = ones(m, 1);
            KAt = [Kernel(At, X, opts.kernel) et];
            D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
            D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
            yt = sign(D2-D1);
            yt(yt==0) = 1;
            yTest{t} = yt;
        end
    end

    function [ Alpha2 ] = SSR_MU_P(H1, H2, Alpha1, C1)
        % safe screening rules for $\mu$, $p$
        P = chol(H2, 'upper');
        LL = (H1+H2)*Alpha1;
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P'\(H1*Alpha1)+P*Alpha1);
        Alpha2 = Inf(size(Alpha1));
        Alpha2(LL - RR > 2) = 0;
        Alpha2(LL + RR < 2) = C1;
    end

    function [ Alpha2 ] = SSR_C(H2, Alpha1, C1, C0)
        k1 = (C1 + C0)/C0;
        k2 = (C1 - C0)/C0;
        % safe screening rules for $C$
        P = chol(H2, 'upper');
        LL = H2*Alpha1*k1;
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P*Alpha1*k2);
        Alpha2 = Inf(size(Alpha1));
        Alpha2(LL - RR > 2) = 0;
        Alpha2(LL + RR < 2) = C1;
    end

end