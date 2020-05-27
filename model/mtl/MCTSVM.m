function [ yTest, Time ] = MCTSVM( xTrain, yTrain, xTest, opts )
%MTCTSVM 此处显示有关此函数的摘要
% Multitask Centroid Twin Support Vector Machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, PI ] = GetAllData(xTrain, yTrain, TaskNum);
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
                    [ H1, H2 ] = GetHessian(Q, P, R, S, params);
                case {'p','p1'}
                    [ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, PI, TaskNum, params);
            end
        else
            [ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, PI, TaskNum, params);
            [ H1, H2 ] = GetHessian(Q, P, R, S, params);
        end
        [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, params);
        [ Time(i, 1) ] = toc;
        [ U, V ] = GetWeight(EEF, FFE, EEFt, FFEt, Alpha, Gamma, I, TaskNum, params);
        [ yTest{i} ] = Predict(xTest, C, TaskNum, U, V, params.kernel);
    end
else
    tic;
    [ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, PI, TaskNum, opts);
    [ H1, H2 ] = GetHessian(Q, P, R, S, opts);
    [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, opts);
    Time = toc;
    [ U, V ] = GetWeight(EEF, FFE, EEFt, FFEt, Alpha, Gamma, I, TaskNum, opts);
    [ yTest ] = Predict(xTest, C, TaskNum, U, V, opts.kernel);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.rho ~= p2.rho
            change = 'mu';
            step = length(opts.rho);
        elseif p1.p ~= p2.p
            change = 'p';
            step = length(opts.p);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(opts.kernel.p1);
                else
                    throw(MException('MCTSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MCTSVM', 'Change: no parameter changed'));
            end
        end
     end

    function [ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, PI, TaskNum, opts)
        kernel = opts.kernel;
        p = opts.p;
        q = opts.p;
        %         
        A_ = X(Y==1,:);
        B_ = X(Y==-1,:);
        % reconstruct all tasks
        % centroids of all task
        A = [A_; p*mean(A_)];
        B = [B_; q*mean(B_)];
        % centroid of t-th task
        AT = mat2cell(A_, PI(1,:));
        BT = mat2cell(B_, PI(2,:));
        XT = cell(TaskNum, 1);
        YT = cell(TaskNum, 1);
        for t = 1 : TaskNum
            AT{t} = [AT{t}; p*mean(AT{t})];
            BT{t} = [BT{t}; q*mean(BT{t})];
            XT{t} = [AT{t}; BT{t}];
            yp = ones(size(AT{t}, 1), 1);
            yn = -ones(size(BT{t}, 1), 1);
            YT{t} = [yp; yn];
        end
        M = cell2mat(AT);
        N = cell2mat(BT);
        [ C, ~, ~, I ] = GetAllData( XT, YT, TaskNum );
        % 核函数
        E = [Kernel(A, C, kernel) ones(size(A, 1), 1)];
        F = [Kernel(B, C, kernel) ones(size(B, 1), 1)];
        M = [Kernel(M, C, kernel) ones(size(M, 1), 1)];
        N = [Kernel(N, C, kernel) ones(size(N, 1), 1)];
        % 单位向量
        [m1, ~] = size(M);
        [m2, ~] = size(N);
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        % 得到Q,R矩阵
        EEF = Cond(E'*E)\N';
        FFE = Cond(F'*F)\M';
        Q = N*EEF;
        R = M*FFE;
        % 得到P,S矩阵
        P = cell(TaskNum, 1);
        S = cell(TaskNum, 1);
        EEFt = cell(TaskNum, 1);
        FFEt = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = [Kernel(AT{t}, C, kernel) ones(size(AT{t}, 1), 1)];
            Ft = [Kernel(BT{t}, C, kernel) ones(size(BT{t}, 1), 1)];
            EEFt{t} = Cond(Et'*Et)\(Ft');
            FFEt{t} = Cond(Ft'*Ft)\(Et');
            P{t} = Ft*EEFt{t};
            S{t} = Et*FFEt{t};
        end
        P = spblkdiag(P{:});
        S = spblkdiag(S{:});
    end

    function [ H1, H2 ] = GetHessian(Q, P, R, S, opts)
        Sym = @(H) (H+H')/2 + 1e-5;
        H1 = Sym(Q + 1/opts.rho*P);
        H2 = Sym(R + 1/opts.rho*S);
    end

    function [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1,m2, opts)
        Alpha = quadprog(H1,-e2,[],[],[],[],zeros(m2, 1),opts.C*e2,[],opts.solver);
        Gamma = quadprog(H2,-e1,[],[],[],[],zeros(m1, 1),opts.C*e1,[],opts.solver);
    end

    function [ U, V ] = GetWeight(EEF, FFE, EEFt, FFEt, Alpha, Gamma, I, TaskNum, opts)
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        CAlpha = mat2cell(Alpha, I(2,:));
        CGamma = mat2cell(Gamma, I(1,:));
        for t = 1 : TaskNum
            U{t} = u - EEFt{t}*(1/opts.rho*CAlpha{t});
            V{t} = v + FFEt{t}*(1/opts.rho*CGamma{t});
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