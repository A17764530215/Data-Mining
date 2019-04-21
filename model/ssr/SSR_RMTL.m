function [ CVStat, CVTime, CVRate ] = SSR_RMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_RMTL 此处显示有关此函数的摘要
% Safe Screening for RMTL
%   此处显示详细说明

%% Fit
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
solver = opts.solver;
[ ~, step ] = Change(IParams);
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 4);
for i = 1 : n
    Params = GetParams(IParams, i);
    Params.solver = opts.solver;
    tic;
    [ H1 ] = Prepare(X, Y, TaskNum, Params);
    if mod(i, step) == 1
        % solve the first problem
        [ H0, Alpha0 ] = Primal(H1);
    else
        % solve the rest problem
        [ Alpha1 ] = DVI_H(H0, H1, Alpha0, 1);
        [ H0, Alpha0, CVRate(i,1:2) ] = Reduced(H1, Alpha1);
    end
    CVTime(i, 1) = toc;
    [ y_hat, CVRate(i, 3:4) ] = Predict(X, Y, xTest, Alpha0, Params);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_hat, yTest, opts);
end

    function [ change, step ] = Change(IParams)
    % 得到最先变的参数
        p1 = GetParams(IParams, 1);
        p2 = GetParams(IParams, 2);
        if p1.lambda1 ~= p2.lambda1
            change = 'L1';
            step = length(IParams.lambda1);
        elseif p1.lambda2 ~= p2.lambda2
            step = length(IParams.lambda2);
            change = 'L2';
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'H';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
                end
            else 
                throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
            end
        end
    end

    function [ H ] = Prepare(X, Y, TaskNum, opts)
        mu = 1/(2*opts.lambda2);
        nu = TaskNum/(2*opts.lambda1);
        % construct hessian matrix
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        H = Cond(mu*Q + nu*spblkdiag(P{:}));
    end

    function [ H1, Alpha1 ] = Primal(H1)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, e, [], solver);
    end

    function [ H2, Alpha2, Rate ] = Reduced(H2, Alpha2)
        % reduced problem
        R = Alpha2 == Inf;
        S0 = Alpha2 == 0;
        SC = Alpha2 == 1;
        Rate = mean([S0, SC]);
        if mean(R) > 0
            S = S0 | SC;
            f = H2(R,S)*Alpha2(S)-1;
            lb = zeros(size(f));
            ub = ones(size(f));
            [ Alpha2(R) ] = quadprog(H2(R,R), f, [], [], [], [], lb, ub, [], solver);
        end
    end

    function [ yTest, Rate ] = Predict(X, Y, xTest, Alpha, opts)
        % extract opts
        mu = 1/(2*opts.lambda2);
        nu = TaskNum/(2*opts.lambda1);
        % predict
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = predict(Ht, Y, Alpha);
            yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(mu*y0 + nu*yt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
        Rate = mean([abs(Alpha)<1e-7, abs(Alpha-1)<1e-7]);
        
            function [ y ] = predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end

end