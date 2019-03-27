function [  CVStat, CVTime, CVRate ] = SSRM_IRMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_IRMTL 此处显示有关此函数的摘要
% Safe Screening for IRMTL
%   此处显示详细说明

%% Fit
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 2);
Alpha = cell(n, 1);
for i = 1 : n
    Params = GetParams(IParams, i);
    Params.solver = opts.solver;
    tic;
    [ H2 ] = GetHessian(X, Y, TaskNum, Params);
    if i == 1 ||  ~EqualsTo(Params, LastParams)
        % solve the first problem
        [ Alpha{i} ] = IRMTL(H2, Params);
    else
        % solve the rest problem
        [ Alpha{i} ] = SSR1(H1, H2, Alpha{i-1});
        [ Alpha{i}, CVRate(i,1) ] = Reduced_IRMTL(H2, Alpha{i}, Params);
    end
    CVTime(i, 1) = toc;
    [ y_hat, CVRate(i, 2) ] = Predict(X, Y, xTest, Alpha{i}, Params);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_hat, yTest, opts);
    LastParams = Params;
end

%% Compare
    function [ b ] = EqualsTo(p1, p2)
        k1 = p1.kernel;
        k2 = p2.kernel;
        if strcmp(k1.kernel, 'rbf') && strcmp(k2.kernel, 'rbf')
            b = k1.p1 == k2.p1 && p1.C == p2.C;
        else
            b = p1.mu == p2.mu;
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
            y = sign(y0/mu + yt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
        Rate = mean(abs(Alpha)<1e-7 | abs(Alpha-C)<1e-7);
        
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
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, ub, [], []);
    end

%% SSR for $\mu$
    function [ Alpha2 ] = SSR1(H1, H2, Alpha1)
        % safe screening rules for $\mu$, $p$
        P = chol(H2, 'upper');
        LL = (H1+H2)*Alpha1/2;
        RL = sqrt(sum(P.*P, 1))';
        RR = RL*norm(P'\(H1*Alpha1)+P*Alpha1)/2;
        Alpha2 = Inf(size(Alpha1));
        Alpha2(LL - RR > 1) = 0;
        Alpha2(LL + RR < 1) = 1;
    end

%% Reduced-RMTL
    function [ Alpha2, Rate ] = Reduced_IRMTL(H2, Alpha2, Params)
        % reduced problem
        R = Alpha2 == Inf;
        S = Alpha2 ~= Inf;
        Rate = mean(S);
        if Rate < 1
            f = H2(R,S)*Alpha2(S)-1;
            lb = zeros(size(f));
            ub = Params.C*ones(size(f));
            [ Alpha2(R) ] = quadprog(H2(R,R), f, [], [], [], [], lb, ub, [], []);
        end
    end

%% Get Hessian
    function [ H ] = GetHessian(X, Y, TaskNum, opts)
        symmetric = @(H) (H+H')/2;
        % construct hessian matrix
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
        end
        H = Cond(Q/opts.mu + P);
        H = symmetric(H);
    end
end