function [  CVStat, CVTime, CVRate ] = SSR_CRMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_IRMTL 此处显示有关此函数的摘要
% Safe Screening for IRMTL
%   此处显示详细说明

[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
Sym = @(H) ((H+H')/2 + 1e-5*speye(size(H)));
[ change, step ] = Change(IParams);
[ dcdm ] = isfield(IParams, 'dcdm');
n = GetParamsCount(IParams);
CVStat = zeros(n, opts.IndexCount, TaskNum);
CVTime = zeros(n, 1);
CVRate = zeros(n, 6);
for i = 1 : n
    params1 = GetParams(IParams, i);
    params1.solver = opts.solver;
    tic;
    if mod(i, step) ~= 1
        % solve the rest problem
        switch change
            case 'C'
                [ Alpha1 ] = DVI_C(H1, Alpha0, params1.C, params0.C);
            case 'mu'
                H0 = H1;
                [ H1 ] = Sym(params1.mu*Q + (1-params1.mu)*TaskNum*P);
                [ Alpha1 ] = DVI_H(H0, H1, Alpha0, params1.C);
            case 'p1'
                H0 = H1;
                [ Q, P ] = Prepare(X, Y, T, TaskNum, params1);
                [ H1 ] = Sym(params1.mu*Q + (1-params1.mu)*TaskNum*P);
                [ Alpha1 ] = DVI_H(H0, H1, Alpha0, params1.C);
            otherwise
                throw(MException('SSR_CRMTL', 'Change: no parameter changed'));
        end
        [ Alpha0, S, CVRate(i,1:2) ] = Reduced(H1, Alpha1, params1);
    else
        % solve the first problem
        [ Q, P ] = Prepare(X, Y, T, TaskNum, params1);
        [ H1 ] = Sym(params1.mu*Q + (1-params1.mu)*TaskNum*P);
        [ Alpha0 ] = Primal(H1, params1);
    end
    CVTime(i, 1) = toc;
    % 检验筛选出来的0和C，是不是原有的0和C
    if mod(i, step) ~= 1
        [ Alpha1 ] = Primal(H1, params1);
        [ CVRate(i, 5:6) ] = Compare(Alpha1, Alpha0, S);
    end
    % 预测
    [ y_, CVRate(i, 3:4) ] = Predict(xTest, X, Y, T, Alpha0, TaskNum, params1);
    CVStat(i,:,:) = MTLStatistics(TaskNum, y_, yTest, opts);
    params0 = params1;
end

    function [ rate ] = Compare(Alpha1, Alpha0, S)
        Diff = abs(Alpha1-Alpha0);
        rate(1) = max(Diff(S));
        rate(2) = max(Diff);
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
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        P = spblkdiag(P{:});
    end

    function [ Alpha1 ] = Primal(H1, opts)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        ub = repmat(opts.C, size(H1,1), 1);
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, ub, [], opts.solver);
    end

    function [ Alpha1, S, Rate ] = Reduced(H1, Alpha1, opts)
        % reduced problem
        R = Alpha1 == Inf;
        S0 = Alpha1 == 0;
        SC = Alpha1 == opts.C;
        S = S0 | SC;
        Rate = mean([S0, SC]);
        if find(R, 1) > 0
            f = (H1(S,R)'+H1(R,S))*Alpha1(S)/2-1;
            lb = zeros(size(f));
            ub = repmat(opts.C, size(f));
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

    function [ yTest, Rate ] = Predict(xTest, X, Y, T, Alpha, TaskNum, opts)
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