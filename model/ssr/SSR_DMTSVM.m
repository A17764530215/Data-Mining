function [ CVStat, CVTime, CVRate ] = SSR_DMTSVM( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_QUAD_SOLVER 此处显示有关此函数的摘要
% Safe Screening for DMTSVM
%   此处显示详细说明

%% Fit
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
Sym = @(H) (H+H')/2;
solver = opts.solver;
[ change, step ] = Change(IParams);
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 4);
for i = 1 : n
    Params = GetParams(IParams, i);
    tic;
    C1 = Params.C1;
    if mod(i, step) ~= 1
        C0 = LastParams.C1;
        % solve the rest problem
        if change == 'C'
            [ Alpha1 ] = DVI_C(H2, Alpha0, C1, C0);
            [ Gamma1 ] = DVI_C(H3, Gamma0, C1, C0);
        else
            if change == 'P'
                [ Q, P, R, S, EEF, FFE, EEFc, FFEc ] = Prepare(X, Y, N, TaskNum, Params);
            end
            H0 = H2; H1 = H3;
            [ H2, H3 ] = GetHessian(Q, P, R, S, TaskNum, Params);
            [ Alpha1 ] = DVI_H(H0, H2, Alpha0, C1);
            [ Gamma1 ] = DVI_H(H1, H3, Gamma0, C1);
        end
        [ CVRate(i,1:2) ] = GetRate([ Alpha1; Gamma1 ], C1);
        [ Alpha0 ] = Reduced(H2, Alpha1, C1);
        [ Gamma0 ] = Reduced(H3, Gamma1, C1);
    else
        % solve the first problem
        [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, Params);
        [ H2, H3 ] = GetHessian(Q, P, R, S, TaskNum, Params);
        [ Alpha0 ] = Primal(H2, -e2, zeros(m2, 1), C1*e2);
        [ Gamma0 ] = Primal(H3, -e1, zeros(m1, 1), C1*e1);
    end
    [ CVTime(i, 1) ] = toc;
    % 预测
    [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha0, Gamma0, N, TaskNum, Params);
    [ y_hat ] = Predict(xTest, X, TaskNum, U, V, Params);
    [ CVRate(i,3:4) ] = GetTotalRate([ Alpha0; Gamma0 ], C1);
    [ CVStat(i,:,:) ] = MTLStatistics(TaskNum, y_hat, yTest, opts);
    LastParams = Params;
end

    function [ change, step ] = Change(IParams)
    % 得到最先变的参数
        p1 = GetParams(IParams, 1);
        p2 = GetParams(IParams, 2);
        if p1.C1 ~= p2.C1
            change = 'C';
            step = length(IParams.C1);
        elseif p1.rho ~= p2.rho
            step = length(IParams.rho);
            change = 'M';
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'P';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('SSR_DMTSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('SSR_DMTSVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts)
        mu = opts.rho;
        H1 = Cond(Sym(mu*Q + TaskNum*(1-mu)*P));
        H2 = Cond(Sym(mu*R + TaskNum*(1-mu)*S));
    end

    function [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, opts)
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
        EEF = Cond(E'*E)\F';
        FFE = Cond(F'*F)\E';
        Q = F*EEF;
        R = E*FFE;
        % 得到P,S矩阵
        Ec = mat2cell(E, N(1,:));
        Fc = mat2cell(F, N(2,:));
        EEFc = cell(TaskNum, 1);
        FFEc = cell(TaskNum, 1);
        P = cell(TaskNum, 1);
        S = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = Ec{t}; Ft = Fc{t};
            EEFc{t} = Cond(Et'*Et)\Ft';
            FFEc{t} = Cond(Ft'*Ft)\Et';
            P{t} = Ft*EEFc{t};
            S{t} = Et*FFEc{t};
        end
        P = spblkdiag(P{:});
        S = spblkdiag(S{:});
    end

    function [ Alpha ] = Primal(H, f, lb, ub)
        Alpha = quadprog(H,f,[],[],[],[],lb,ub,[],solver);
    end

    function [ Alpha, R, S ] = Reduced(H, Alpha, C1)
        % reduced problem
        [ ~, R, S ] = GetRate(Alpha, C1);
        if mean(R) > 0
            f = H(R,S)*Alpha(S)-1;
            lb = zeros(size(f));
            ub = C1*ones(size(f));
            Alpha(R) = quadprog(H(R,R),f,[],[],[],[],lb,ub,[],solver);
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
        mu = opts.rho;
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = mu*u - EEFc{t}*(TaskNum*(1-mu)*CAlpha{t});
            V{t} = mu*v + FFEc{t}*(TaskNum*(1-mu)*CGamma{t});
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

end