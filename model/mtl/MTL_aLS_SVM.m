function [ yTest, Time ] = MTL_aLS_SVM( xTrain, yTrain, xTest, opts )
%MTL_aLS_SVM 此处显示有关此函数的摘要
% Multi-task asymmetric least squares support vector machine
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
                case {'C','rho'}
                    % 无需额外计算
                case 'p1'
                    % 重新计算Hessian阵
                    [ XX, Q, P ] = Prepare(X, Y, T, TaskNum, params);
                otherwise
                    throw(MException('MTL:MTL_aLS_SVM', 'no parameter changed'));
            end
        else
            [ XX, Q, P ] = Prepare(X, Y, T, TaskNum, params);
        end
        [ G ] = GetHessian(Q, P, params);
        [ Gamma ] = Primal(G, Y,params);
        [ Time(i, 1) ] = toc;
        [ b, Theta ]  = GetThetaB(Gamma, Y, XX, T, TaskNum, params);
        [ yTest{i} ] = Predict(xTest, X, Y, T, TaskNum, Theta, b, params);
    end
else
    tic;
    [ XX, Q, P ] = Prepare(X, Y, T, TaskNum, opts);
    [ G ] = GetHessian(Q, P, opts);
    [ Gamma ] = Primal(G, Y,opts);
    Time = toc;
    [ b, Theta ]  = GetThetaB(Gamma, Y, XX, T, TaskNum, opts);
    [ yTest ] = Predict(xTest, X, Y, T, TaskNum, Theta, b, opts);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C1 ~= p2.C1
            change = 'C';
            step = length(opts.C1);
        elseif p1.C2 ~= p2.C2
            change = 'C';
            step = length(opts.C2);
        elseif p1.rho ~= p2.rho
            change = 'rho';
            step = length(opts.rho);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('MTL:MTL_aLS_SVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:MTL_aLS_SVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ XX, Q, P ] = Prepare(X, Y, T, TaskNum, opts)
        kernel = opts.kernel;
        % calculate kernel matrix
        XX = Kernel(X, X, kernel);
        Q = Y.*XX.*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
        end
    end

    function [ G ] = GetHessian(Q, P, opts)
        C1 = opts.C1;
        C2 = opts.C2;
        rho = opts.rho;
        % $ Hessian matrix
        K = Q + 1/C1 * P;
        H = [K,-K;-K,K];
        % R
        I = speye(size(K));
        LT = I/(rho*rho);
        RT = I/(rho*(1-rho));
        LB = I/((1-rho)*rho);
        RB = I/((1-rho)*(1-rho));
        R = [LT, RT; LB, RB];
        % Hessian matrix
        G = H + 1/C2*R;
    end

    function [ Gamma ] = Primal(G, Y,opts)
        e = ones(size(Y));
        f = [-e;e];
        Aeq = [Y;-Y]';
        beq = 0;
        lb = zeros(size(f));
        ub = Inf(size(f));
        Gamma = quadprog(G,f,[],[],Aeq,beq,lb,ub,[],opts.solver);
    end

    function [ b, Theta ]  = GetThetaB(Gamma, Y, XX, T, TaskNum, opts)
        C1 = opts.C1;
        C2 = opts.C2;
        rho = opts.rho;
        % extract alpha and gamma
        Gamma = reshape(Gamma, length(Gamma)/2, 2);
        Alpha = Gamma(:,1);
        Beta = Gamma(:,2);
        Theta = Alpha - Beta;
        % calculate b         
        b = zeros(TaskNum, 1);
        for t = 1 : TaskNum
            Tt= T==t;
            alpha = Alpha(Tt,1);
            beta = Beta(Tt,1);
            % support vectors
            qt = 1/C2*(alpha/rho+beta/(1-rho));
            y_hat1 = (1-1/rho*qt)./Y(Tt,1);
            y_hat2 = (1-1/(1-rho)*qt)./Y(Tt,1);
            xwt = XX(Tt,:).*Y'*Theta+XX(Tt,Tt).*Y(Tt,1)'*Theta(Tt,1)/C1;
            b_hat1 = y_hat1 - xwt;
            b_hat2 = y_hat2 - xwt;
            b(t, 1) = mean([b_hat1(alpha>0); b_hat2(beta>0)]);
        end
    end

    function [ yTest ] = Predict(xTest, X, Y, T, TaskNum, Theta, b, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = Ht.*Y'*Theta;
            yt = Ht(:,Tt).*Y(Tt,1)'*Theta(Tt,1)/opts.C1;
            y = sign(y0 + yt + b(t,1));
            y(y==0) = 1;
            yTest{t} = y;
        end
    end

end