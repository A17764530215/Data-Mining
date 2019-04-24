function [ yTest, Time ] = CRMTL( xTrain, yTrain, xTest, opts )
%IRMTL 此处显示有关此函数的摘要
% Regularized Multi-task Learning
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
count = GetParamsCount(opts);
if count > 1
    % 网格搜索加速
    yTest = zeros(count, size(xTest, 1));
    Time = zeros(count, 1);
    [ change, step ] = Change(opts);
    for i = 1 : count
        params = GetParams(opts, i);
        tic;
        if mod(i, step) ~= 1
            switch change 
                case 'C'
                    % 无需额外计算
                case 'mu'
                    % 重新计算Hessian阵
                    [ H ] = GetHessian(Q, P, TaskNum, params);
                case 'p1'
                    % 重新计算Hessian阵
                    [ Q, P ] = Prepare(X, Y, T, TaskNum, params);
                    [ H ] = GetHessian(Q, P, TaskNum, params);
                otherwise
                    throw(MException('CRMTL', 'no parameter changed'));
            end
        else
            % 重新计算Hessian阵
            [ Q, P ] = Prepare(X, Y, T, TaskNum, params);
            [ H ] = GetHessian(Q, P, TaskNum, params);
        end
        % 求解优化模型
        [ Alpha ] = Primal(H, opts);
        Time(i, 1) = toc;
        % 预测
        [ yTest(i, :) ] =  Predict(xTest, X, Y, T, Alpha, TaskNum, params);
    end
else
    % 无网格搜索
    tic;
    [ Q, P ] = Prepare(X, Y, T, TaskNum, opts);
    [ H ] = GetHessian(Q, P, TaskNum, opts);
    [ Alpha ] = Primal(H, opts);
    Time = toc;
    % 预测
    [ yTest ] =  Predict(xTest, X, Y, T, Alpha, TaskNum, opts);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.mu ~= p2.mu
            change = 'mu';
            step = length(opts.mu);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(opts.kernel.p1);
                else
                    throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
                end
            else 
                throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
            end
        end
     end

    function [ Q, P ] = Prepare(X, Y, T, TaskNum, opts)
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        P = spblkdiag(P{:});
    end

    function [ H ] = GetHessian(Q, P, TaskNum, opts)
        H = Cond(opts.mu*Q + (1-opts.mu)*TaskNum*P);
    end

    function [ Alpha ] = Primal(H, opts)
        e = ones(size(H, 1));
        lb = zeros(size(H, 1));
        [ Alpha ] = quadprog(H,-e,[],[],[],[],lb,opts.C*e,[],opts.solver);
    end

    function [ yTest ] =  Predict(xTest, X, Y, T, Alpha, TaskNum, opts)
        mu = opts.mu;
        kernel = opts.kernel;
        % predict
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, kernel);
            y0 = predict(Ht, Y, Alpha);
            yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(mu*y0 + (1-mu)*TaskNum*yt);
            y(y==0) = 1;
            yTest{t} = y;
        end

            function [ y ] = predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end
end