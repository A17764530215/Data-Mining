function [ yTest, Time ] = MCTSVM( xTrain, yTrain, xTest, opts )
%MTCTSVM 此处显示有关此函数的摘要
% Multitask Centroid Twin Support Vector Machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, I ] = GetAllData(xTrain, yTrain, TaskNum);

tic;
[ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, I, TaskNum, opts);
[ H1, H2 ] = GetHessian(Q, P, R, S, opts);
[ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1, m2, opts);
Time = toc;

[ U, V ] = GetWeight(EEF, FFE, EEFt, FFEt, Alpha, Gamma, I, TaskNum, opts);
[ yTest ] = Predict(xTest, C, TaskNum, U, V);

    function [ Q, P, R, S, EEF, FFE, EEFt, FFEt, C, I, m1, m2, e1, e2 ] = Prepare(X, Y, I, TaskNum, opts)
        kernel = opts.kernel;
        p = opts.p;
        q = opts.q;
        %         
        A_ = X(Y==1,:);
        B_ = X(Y==-1,:);
        % reconstruct all tasks
        % centroids of all task
        A = [A_; p*mean(A_)];
        B = [B_; q*mean(B_)];
        % centroid of t-th task
        AT = mat2cell(A_, I(1,:));
        BT = mat2cell(B_, I(2,:));
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
        P = sparse(0, 0);
        S = sparse(0, 0);
        EEFt = cell(TaskNum, 1);
        FFEt = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = [Kernel(AT{t}, C, kernel) ones(size(AT{t}, 1), 1)];
            Ft = [Kernel(BT{t}, C, kernel) ones(size(BT{t}, 1), 1)];
            EEFt{t} = Cond(Et'*Et)\(Ft');
            FFEt{t} = Cond(Ft'*Ft)\(Et');
            P = blkdiag(P, Ft*EEFt{t});
            S = blkdiag(S, Et*FFEt{t});
        end
    end

    function [ H1, H2 ] = GetHessian(Q, P, R, S, opts)
        H1 = Cond(Q + 1/opts.rho*P);
        H2 = Cond(R + 1/opts.lambda*S);
    end

    function [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, m1,m2, opts)
        Sym = @(H) (H+H')/2;
        Alpha = quadprog(Sym(H1),-e2,[],[],[],[],zeros(m2, 1),opts.C*e2,[],optssolver);
        Gamma = quadprog(Sym(H2),-e1,[],[],[],[],zeros(m1, 1),opts.C*e1,[],opts.solver);
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
            V{t} = v + FFEt{t}*(1/opts.lambda*CGamma{t});
        end
    end

    function [ yTest ] = Predict(xTest, X, TaskNum, U, V)
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