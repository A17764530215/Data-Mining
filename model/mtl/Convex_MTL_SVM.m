function [ yTest, Time ] =  Convex_MTL_SVM( xTrain, yTrain, xTest, opts )
%Convex_MTL_SVM 此处显示有关此函数的摘要
% A Convex Formulation of SVM-Based Multi-task Learning
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
Sym = @(H) (H+H')/2 + 1e-7*speye(size(H));
solver = opts.solver;
opts.solver = [];
opts = rmfield(opts, 'solver');
count = GetParamsCount(opts);
% 提前计算约束条件
[ f, Aeq, beq, lb, ub ] = Constraints(Y, T, TaskNum);
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
                    [ H ] = Sym(params.mu*params.mu*Q + (1-params.mu)*(1-params.mu)*P);
                case 'p1'
                    % 重新计算Hessian阵
                    [ Q, P ] = GetHessian(X, Y, T, TaskNum, params);
                    [ H ] = Sym(params.mu*params.mu*Q + (1-params.mu)*(1-params.mu)*P);
                otherwise
                    throw(MException('Convex_MTL_SVM', 'no parameter changed'));
            end
        else
            % 重新计算Hessian阵
            [ Q, P ] = GetHessian(X, Y, T, TaskNum, params);
            [ H ] = Sym(params.mu*params.mu*Q + (1-params.mu)*(1-params.mu)*P);
        end
        % 求解优化模型
        [ Alpha ] = quadprog(H,f,[],[],Aeq,beq,lb,params.C*ub,[],solver);
        [ b ] = GetBias(H, Y, T, Alpha, TaskNum, params);
        Time(i, 1) = toc;
        % 预测        
        [ yTest{i} ] =  Predict(xTest, X, Y, T, Alpha, b, TaskNum, params);
    end
else
    % 无网格搜索
    tic;
    [ Q, P ] = GetHessian(X, Y, T, TaskNum, opts);
    [ H ] = Sym(opts.mu*opts.mu*Q + (1-opts.mu)*(1-opts.mu)*P);
    [ Alpha ] = quadprog(H,f,[],[],Aeq,beq,lb,opts.C*ub,[],solver);
    [ b ] = GetBias(H, Y, T, Alpha, TaskNum, opts);
    Time = toc;
    % 预测    
    [ yTest ] =  Predict(xTest, X, Y, T, Alpha, b, TaskNum, opts);
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

    function [ Q, P ] = GetHessian(X, Y, T, TaskNum, opts)
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        P = spblkdiag(P{:});
    end

    function [ f, Aeq, beq, lb, ub ] = Constraints(Y, T, TaskNum)
        f = -ones(size(Y));
        Aeq = repmat(Y', TaskNum, 1);
        for t = 1 : TaskNum
            Aeq(t, T~=t) = 0;
        end
        Aeq = sparse(Aeq);
        beq = zeros(TaskNum, 1);
        lb = zeros(size(Y));
        ub = ones(size(Y));
    end

    function [ b ] = GetBias(H, Y, T, Alpha, TaskNum, opts)
       b = zeros(TaskNum, 1);
       I = (Alpha > 0) & (Alpha < opts.C);
       for t = 1 : TaskNum
           Tt = T == t; % samples in the t-th task
           It = Tt & I; % support vectors in the t-th task
           b(t) = mean(Y(It)-(H(It,:)*(Y.*Alpha)+H(It,Tt)*(Y(Tt).*Alpha(Tt))));
       end
    end

    function [ yTest ] =  Predict(xTest, X, Y, T, Alpha, b, TaskNum, opts)
        mu = opts.mu;
        kernel = opts.kernel;
        % predict
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            K = Kernel(xTest{t}, X, kernel);
            y = sign(mu*K*(Y.*Alpha) + (1-mu)*K(:,Tt)*(Y(Tt).*Alpha(Tt)) + b(t));
            y(y==0) = 1;
            yTest{t} = y;
        end
    end

end

