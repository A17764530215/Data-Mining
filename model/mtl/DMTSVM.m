function [ yTest, Time ] = DMTSVM( xTrain, yTrain, xTest, opts )
%DMTSVM 此处显示有关此函数的摘要
% Multi-Task Twin Support Vector Machine
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
                case 'C'                  
                    % 无需额外计算
                case 'mu'
                    % 重新计算Hessian阵
                    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
                case 'p1'
                    % 重新计算Hessian阵
                    [ Q, P, R, S, EEF, FFE, EEFc, FFEc ] = Prepare(X, Y, N, TaskNum, params.kernel);
                    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
                otherwise
                    throw(MException('MTL:DMTSVM', 'no parameter changed'));
            end
        else
            % 新一轮网格搜索
            [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, params.kernel);
            [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, params);
        end
        % 重新求解优化问题
        [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, params);
        [ Time(i, 1) ] = toc;
        % 预测
        [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha, Gamma, N, TaskNum, params);
        [ yTest{i} ] = Predict(xTest, X, TaskNum, U, V, params.kernel);
    end
else
    % 无网格搜索
    tic;
    [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, opts.kernel);
    [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts);
    [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, opts);
    Time = toc;
    % 预测
    [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha, Gamma, N, TaskNum, opts);
    [ yTest ] = Predict(xTest, X, TaskNum, U, V, opts.kernel);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.rho1 ~= p2.rho1
            change = 'mu';
            step = length(opts.rho1);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(opts.kernel.p1);
                else
                    throw(MException('MTL:DMTSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:DMTSVM', 'Change: no parameter changed'));
            end
        end
     end

    function [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts)
        Sym = @(H) (H+H')/2 + 1e-5*speye(size(H));
        H1 = Sym(Q + TaskNum/opts.rho*P);
        H2 = Sym(R + TaskNum/opts.rho*S);
    end

    function [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, opts)
        Alpha = quadprog(H1,-e2,[],[],[],[],zeros(m2, 1),opts.C*e2,[],opts.solver);
        Gamma = quadprog(H2,-e1,[],[],[],[],zeros(m1, 1),opts.C*e1,[],opts.solver);
    end

    function [ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha, Gamma, N, TaskNum, opts)
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = u - EEFc{t}*(TaskNum/opts.rho*CAlpha{t});
            V{t} = v + FFEc{t}*(TaskNum/opts.rho*CGamma{t});
        end
    end

    function [ yTest ] = Predict(xTest, X, TaskNum, U, V, kernel)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Xt = xTest{t};
            [m, ~] = size(Xt);
            et = ones(m, 1);
            KXt = [Kernel(Xt, X, kernel) et];
            D1 = abs(KXt * U{t})/norm(U{t}(1:end-1));
            D2 = abs(KXt * V{t})/norm(V{t}(1:end-1));
            yt = sign(D2-D1);
            yt(yt==0) = 1;
            yTest{t} = yt;
        end
    end

end