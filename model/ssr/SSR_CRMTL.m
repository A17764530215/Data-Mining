function [  CVStat, CVTime, CVRate, CVGap ] = SSR_CRMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_IRMTL 此处显示有关此函数的摘要
% Safe Screening for IRMTL
%   此处显示详细说明

%% Fit
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
[ change, step ] = Change(IParams);
[ dcdm ] = isfield(IParams, 'dcdm');
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 1);
CVRate = zeros(n, 4);
CVGap = zeros(n, 2);
for i = 1 : n
    params = GetParams(IParams, i);
    tic;
    C1 = params.C;
    if mod(i, step) ~= 1
        C0 = LastParams.C;
        % solve the rest problem
        switch change
            case 'C'
                [ Alpha1 ] = DVI_C(H1, Alpha0, C1, C0);
            case 'mu'
                H0 = H1;
                [ H1 ] = GetHessian(Q, P, TaskNum, params);
                [ Alpha1 ] = DVI_H(H0, H1, Alpha0, C1);
            case 'p1'
                H0 = H1;
                [ Q, P ] = Prepare(X, Y, T, TaskNum, params);
                [ H1 ] = GetHessian(Q, P, TaskNum, params);
                [ Alpha1 ] = DVI_H(H0, H1, Alpha0, C1);
            otherwise
                throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
        end
        [ Alpha0, CVRate(i,1:2) ] = Reduced(H1, Alpha1, params);
        [ CVGap(i, 2) ] = DualGap(H1, Alpha0, params);
    else
        % solve the first problem
        [ Q, P ] = Prepare(X, Y, T, TaskNum, params);
        [ H1 ] = GetHessian(Q, P, TaskNum, params);
        [ Alpha0 ] = Primal(H1, params);
    end
    CVTime(i, 1) = toc;
    % 预测
    [ Alpha1 ] = Primal(H1, params);
    [ CVGap(i, 1) ] = DualGap(H1, Alpha1, params);
    [ y_, CVRate(i, 3:4) ] = Predict(X, Y, T, TaskNum, xTest, Alpha0, params);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_, yTest, opts);
    LastParams = params;
end

    function [ change, step ] = Change(IParams)
    % 得到最先变的参数
        p1 = GetParams(IParams, 1);
        p2 = GetParams(IParams, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(IParams.C);
        elseif p1.mu ~= p2.mu
            step = length(IParams.mu);
            change = 'mu';
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
                end
            else 
                throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
            end
        end
    end

    function [ Q, P ] = Prepare(X, Y, T, TaskNum, opts)
        % construct hessian matrix
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        P = spblkdiag(P{:});
    end

    function [ H ] = GetHessian(Q, P, TaskNum, opts)
        Sym = @(H) (H+H')/2 + 1e-5*speye(size(H));
        H = Sym(opts.mu*Q + (1-opts.mu)*TaskNum*P);
    end

    function [ Alpha1 ] = Primal(H1, opts)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        ub = opts.C*e;
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, ub, [], opts.solver);
    end

    function [ Alpha1, Rate ] = Reduced(H1, Alpha1, opts)
        % reduced problem
        R = Alpha1 == Inf;
        S0 = Alpha1 == 0;
        SC = Alpha1 == opts.C;
        Rate = mean([S0, SC]);
        if mean(R) > 0
            S = S0 | SC;
            f = H1(R,S)*Alpha1(S)-1;
            lb = zeros(size(f));
            ub = opts.C*ones(size(f));
            if dcdm
                [ Alpha1(R) ] = DCDM_mex(H1(R,R), f, 0, opts.C, opts.dcdm);
            else
                [ Alpha1(R) ] = quadprog(H1(R,R), f, [], [], [], [], lb, ub, [], opts.solver);
            end
        end
    end

    function [ L ] = HingeLoss(y)
        Loss = 1 - y;
        Loss(y > 1) = 0;
        L = sum(Loss);
    end

    function [ Gap ] = DualGap(H1, Alpha1, opts)
        f = H1*Alpha1;
        Gap = (Alpha1'*H1*Alpha1)+opts.C*HingeLoss(f)-sum(Alpha1);
    end

    function [ yTest, Rate ] = Predict(X, Y, T, TaskNum, xTest, Alpha, opts)
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
            y = sign(mu*y0 + (1-mu)*TaskNum*yt);
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