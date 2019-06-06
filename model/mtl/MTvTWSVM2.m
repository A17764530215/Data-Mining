function [ yTest, Time ] = MTvTWSVM2( xTrain, yTrain, xTest, opts )
%MTVTWSVM 此处显示有关此函数的摘要
% Multi-Task $\nu$-Twin Support Vector Machine v2
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
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
                case 'nv'
                    % 无需额外计算
                case 'mu'
                    % 重新计算Hessian阵
                    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
                case 'p1'
                    % 重新计算Hessian阵
                    [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, params.kernel);
                    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
                otherwise
                    throw(MException('MTL:MTvTWSVM2', 'no parameter changed'));
            end
        else
            % 新一轮搜索需要重新初始化
            [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, params.kernel);
            [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
        end
        % 求解模型
        [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, params);
        Time(i, 1) = toc;
        [ U, V ] = GetUV(Alpha, Gamma, EEF, FFE, EEFc, FFEc, N, TaskNum, params);
        % 预测
        [ yTest{i} ] = Predict(xTest, X, TaskNum, U, V, params.kernel);
    end
else
    tic;
    [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, opts.kernel);
    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts);
    [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, opts);
    Time = toc;
    [ U, V ] = GetUV(Alpha, Gamma, EEF, FFE, EEFc, FFEc, N, TaskNum, opts);
    [ yTest ] = Predict(xTest, X, TaskNum, U, V, opts.kernel);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.nv ~= p2.nv
            change = 'nv';
            step = length(opts.nv);
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
                    throw(MException('MTL:MTvTWSVM2', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:MTvTWSVM2', 'Change: no parameter changed'));
            end
        end
    end

    function [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params)
        Sym = @(H) (H+H')/2 + 1e-5*speye(size(H));
        H1 = Sym(params.mu*Q + (1-params.mu)*TaskNum*P);
        H2 = Sym(params.mu*R + (1-params.mu)*TaskNum*S);
    end

    function [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, params)        
        Alpha = quadprog(H1,[],-e2',-params.nv,[],[],zeros(m2, 1),e2/m2,[],params.solver);
        Gamma = quadprog(H2,[],-e1',-params.nv,[],[],zeros(m1, 1),e1/m1,[],params.solver);
    end

    function [ U, V ] = GetUV(Alpha, Gamma, EEF, FFE, EEFc, FFEc, N, TaskNum, params)
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*(params.mu*Alpha);
        v = FFE*(params.mu*Gamma);
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = u - EEFc{t}*(TaskNum*(1-params.mu)*CAlpha{t});
            V{t} = v + FFEc{t}*(TaskNum*(1-params.mu)*CGamma{t});
        end
    end
    
    function [ yTest ] = Predict(xTest, X, TaskNum, U, V, kernel)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            At = xTest{t};
            [m, ~] = size(At);
            et = ones(m, 1);
            KAt = [Kernel(At, X, kernel) et];
            D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
            D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
            yt = sign(D2-D1);
            yt(yt==0) = 1;
            yTest{t} = yt;
        end
    end

end