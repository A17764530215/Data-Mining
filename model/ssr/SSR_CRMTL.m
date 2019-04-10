function [  CVStat, CVTime, CVRate ] = SSR_CRMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_IRMTL 此处显示有关此函数的摘要
% Safe Screening for IRMTL
%   此处显示详细说明

%% Fit
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
solver = opts.solver;
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 4);
for i = 1 : n
    Params = GetParams(IParams, i);
    Params.solver = opts.solver;
    tic;
    [ H1 ] = Prepare(X, Y, TaskNum, Params);
    C1 = Params.C;
    if i > 1
        C0 = LastParams.C;
        % solve the rest problem
        [ bC, bMP ] = EqualsTo(Params, LastParams);
        if bC
            [ Alpha1 ] = SSR_C(H1, Alpha0, C1, C0);
            [ Alpha0, CVRate(i,1:2) ] = Reduced(H1, Alpha1, C1);
        elseif bMP
            [ Alpha1 ] = SSR_MU_P(H0, H1, Alpha0, C1);
            [ Alpha0, CVRate(i,1:2) ] = Reduced(H1, Alpha1, C1);
        else
            % solve the first problem
            [ Alpha0 ] = Primal(H1, C1);
        end
    else
        % solve the first problem
        [ Alpha0 ] = Primal(H1, C1);
    end
    H0 = H1;
    CVTime(i, 1) = toc;
    % 预测
    [ y_hat, CVRate(i, 3:4) ] = Predict(X, Y, xTest, Alpha0, Params);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_hat, yTest, opts);
    LastParams = Params;
end

    function [ bC, bMP ] = EqualsTo(p1, p2)
        k1 = p1.kernel;
        k2 = p2.kernel;
        if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
            bC = k1.p1 == k2.p1 && p1.mu == p2.mu;
            bM = k1.p1 == k2.p1 && p1.C == p2.C;
            bP = p1.C == p2.C && p1.mu == p2.mu;
            bMP = bM || bP;
        else
            bC = p1.mu == p2.mu;
            bMP = p1.C == p2.C;
        end
    end

    function [ H ] = Prepare(X, Y, TaskNum, opts)
        % construct hessian matrix
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        H = Cond(Q + TaskNum/opts.mu*spblkdiag(P{:}));
    end

    function [ Alpha1 ] = Primal(H1, C1)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        ub = C1*e;
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, ub, [], solver);
    end

    function [ Alpha1, Rate ] = Reduced(H1, Alpha1, C1)
        % reduced problem
        R = Alpha1 == Inf;
        S0 = Alpha1 == 0;
        SC = Alpha1 == C1;
        Rate = mean([S0, SC]);
        if mean(R) > 0
            S = S0 | SC;
            f = H1(R,S)*Alpha1(S)-1;
            lb = zeros(size(f));
            ub = C1*ones(size(f));
            [ Alpha1(R) ] = quadprog(H1(R,R), f, [], [], [], [], lb, ub, [], solver);
        end
    end

    function [ Alpha1 ] = SSR_C(H1, Alpha0, C1, C0)
        k1 = (C1+C0)/C0;
        k2 = (C1-C0)/C0;
        % safe screening rules for $C$
        P = chol(H1, 'upper');
        LL = H1*(Alpha0*k1);
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P*Alpha0*k2);
        Alpha1 = Inf(size(Alpha0));
        Alpha1(LL - RR > 2) = 0;
        Alpha1(LL + RR < 2) = C1;
    end

    function [ Alpha1 ] = SSR_MU_P(H0, H1, Alpha0, C1)
        % safe screening rules for $\mu$, $p$
        P = chol(H1, 'upper');
        LL = (H0+H1)*Alpha0;
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P'\((H0*H1)*Alpha0));
        Alpha1 = Inf(size(Alpha0));
        Alpha1(LL - RR > 2) = 0;
        Alpha1(LL + RR < 2) = C1;
    end

    function [ yTest, Rate ] = Predict(X, Y, xTest, Alpha, opts)
        % extract opts
        mu = opts.mu;
        C = opts.C;
        % predict
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = predict(Ht, Y, Alpha);
            yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(y0 + TaskNum/mu*yt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
        Rate = mean([abs(Alpha)<1e-7, abs(Alpha-C)<1e-7]);
        
        function [ y ] = predict(H, Y, Alpha)
            svi = Alpha~=0;
            y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
        end
    end

end