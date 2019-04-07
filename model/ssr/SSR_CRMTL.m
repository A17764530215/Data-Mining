function [  CVStat, CVTime, CVRate ] = SSR_CRMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_IRMTL 此处显示有关此函数的摘要
% Safe Screening for IRMTL
%   此处显示详细说明

%% Fit
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 4);
Alpha = cell(n, 1);
for i = 1 : n
    Params = GetParams(IParams, i);
    Params.solver = opts.solver;
    tic;
    [ H2 ] = GetHessian(X, Y, TaskNum, Params);
    if i > 1
        % solve the rest problem
        [ bC, bMP ] = EqualsTo(Params, LastParams);
        if bC
            [ Alpha{i} ] = SSR_C(H2, Alpha{i-1}, Params, LastParams);
            [ Alpha{i}, CVRate(i,1:2) ] = Reduced_IRMTL(H2, Alpha{i}, Params);
        elseif bMP
            [ Alpha{i} ] = SSR_MU_P(H1, H2, Alpha{i-1}, Params);
            [ Alpha{i}, CVRate(i,1:2) ] = Reduced_IRMTL(H2, Alpha{i}, Params);
        else
            % solve the first problem
            [ Alpha{i} ] = IRMTL(H2, Params);
        end
    else
        % solve the first problem
        [ Alpha{i} ] = IRMTL(H2, Params);
    end
    H1 = H2;
    CVTime(i, 1) = toc;
    % 预测
    [ y_hat, CVRate(i, 3:4) ] = Predict(X, Y, xTest, Alpha{i}, Params);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_hat, yTest, opts);
    LastParams = Params;
end

%% Compare
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

%% Predict
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
        
        Rate(:,1) = mean(abs(Alpha)<1e-7);
        Rate(:,2) = mean(abs(Alpha-C)<1e-7);
        
        function [ y ] = predict(H, Y, Alpha)
            svi = Alpha~=0;
            y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
        end
    end

%% RMTL
    function [ Alpha1 ] = IRMTL(H1, Params)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        ub = Params.C*e;
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, ub, [], [], Params.solver);
    end

%% SSR for $C$
    function [ Alpha2 ] = SSR_C(H2, Alpha1, Params, LastParams)
        C = Params.C;
        C0 = LastParams.C;
        k1 = (C+C0)/C0;
        k2 = (C-C0)/C0;
        % safe screening rules for $C$
        P = chol(H2, 'upper');
        LL = H2*(Alpha1*k1);
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P*Alpha1*k2);
        Alpha2 = Inf(size(Alpha1));
        Alpha2(LL - RR > 2) = 0;
        Alpha2(LL + RR < 2) = C;
    end

%% SSR for $\mu$, $p$
    function [ Alpha2 ] = SSR_MU_P(H1, H2, Alpha1, Params)
        % safe screening rules for $\mu$, $p$
        P = chol(H2, 'upper');
        LL = (H1+H2)*Alpha1;
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P'\((H1*H2)*Alpha1));
        Alpha2 = Inf(size(Alpha1));
        Alpha2(LL - RR > 2) = 0;
        Alpha2(LL + RR < 2) = Params.C;
    end

%% Reduced-RMTL
    function [ Alpha2, Rate ] = Reduced_IRMTL(H2, Alpha2, Params)
        % reduced problem
        R = Alpha2 == Inf;
        S0 = Alpha2 == 0;
        SC = Alpha2 == Params.C;
        Rate = mean([S0, SC]);
        if mean(R) > 0
            S = S0 | SC;
            f = H2(R,S)*Alpha2(S)-1;
            lb = zeros(size(f));
            ub = Params.C*ones(size(f));
            [ Alpha2(R) ] = quadprog(H2(R,R), f, [], [], [], [], lb, ub, [], []);
        end
    end

%% Get Hessian
    function [ H ] = GetHessian(X, Y, TaskNum, opts)
        % construct hessian matrix
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
        end
        H = Cond(Q + TaskNum/opts.mu*P);
    end
end