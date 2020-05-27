function [ yTest, Time ] = MTPSVM(xTrain, yTrain, xTest, opts)
%MTPSVM 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
count = GetParamsCount(opts);
if count > 1
    % 网格搜索加速
    yTest = cell(count, 1);
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
                    [ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, params);
                    [ H ] = GetHessian(Q, P, TaskNum, params);
                otherwise
                    throw(MException('MTL:MTPSVM', 'no parameter changed'));
            end
        else
            % 新一轮搜索需要重新初始化
            [ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, params);
            [ H ] = GetHessian(Q, P, TaskNum, params);
        end
        % 求解模型
        [ Alpha ] = Primal(H, I, E, params);
        Time(i, 1) = toc;
        % 预测
        [ yTest{i} ] = Predict(xTest, X, Y, T, TaskNum, Alpha, params);
    end
else
    % 无网格搜索
    tic;
    [ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, opts);
    [ H ] = GetHessian(Q, P, TaskNum, opts);
    [ Alpha ] = Primal(H, I, E, opts);
    Time = toc;
    % 预测
    [ yTest ] = Predict(xTest, X, Y, T, TaskNum, Alpha, opts);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.lambda ~= p2.lambda
            change = 'mu';
            step = length(opts.lambda);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('MTL:MTPSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:MTPSVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, opts)
        K = Kernel(X, X, opts.kernel);
        Q = Y.*K.*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            y = Y(Tt,:);
            P = blkdiag(P, y.*(K(Tt,Tt) + 1).*y');
        end
        I = speye(size(Q));
        E = ones(size(Y));
    end

    function [ H ] = GetHessian(Q, P, TaskNum, opts)
        H = Q + TaskNum/opts.lambda*P;
    end

    function [ Alpha ] = Primal(H, I, E, opts)
        Alpha = Cond(H + I/opts.C)\E;
    end

    function [ yTest ] = Predict(xTest, X, Y, T, TaskNum, Alpha, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = Predict(Ht, Y, Alpha);
            yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            bt = TaskNum/opts.lambda*Y(Tt,:)'*Alpha(Tt,:);
            y = sign(y0 + TaskNum/opts.lambda * yt + bt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
            function [ y ] = Predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end

end