function [ yTest, Time ] = MTBSVM( xTrain, yTrain, xTest, opts )
%MTBSVM 此处显示有关此函数的摘要
% Multi-task Twin Bounded Support Vector Machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);

tic;
[ Q, R, E, F, EEF, FFE, m1, m2, e1, e2 ] = Prepare(X, Y, N, TaskNum, opts);
[ P, S, EEFt, FFEt ] = GetEachTask(E, F, N, TaskNum, opts);
[ Alpha, Gamma ] = Primal(Q, P, R, S, e1, e2, m1, m2, opts);
Time = toc;
[ U, V ] = GetWeight(Alpha, Gamma, EEF, FFE, EEFt, FFEt, N, TaskNum);
[ yTest ] = Predict(xTest, X, TaskNum, U, V, opts);

    function [ Q, R, E, F, EEF, FFE, m1, m2, e1, e2 ] = Prepare(X, Y, opts) 
        C3 = opts.C3;
        C4 = opts.C3;
        kernel = opts.kernel;
        %
        Yp = Y==1;
        Yn = Y==-1;
        A = X(Yp,:);
        B = X(Yn,:);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        % 核函数
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        E = [Kernel(A, X, kernel) e1];
        F = [Kernel(B, X, kernel) e2];
        % 得到Q,R矩阵
        I = speye(size(E, 2));
        EEF = (E'*E+C3*I)\F';
        FFE = (F'*F+C4*I)\E';
        Q = F*EEF;
        R = E*FFE;
    end

    function [ P, S, EEFt, FFEt ] = GetEachTask(E, F, N, TaskNum, opts)
        rho = opts.rho;
        lambda = opts.rho;
        % 得到P,S矩阵
        Ec = mat2cell(E, N(1,:));
        Fc = mat2cell(F, N(2,:));
        EEFt = cell(TaskNum, 1);
        FFEt = cell(TaskNum, 1);
        P = sparse(0, 0);
        S = sparse(0, 0);
        for t = 1 : TaskNum
            Et = Ec{t}; Ft = Fc{t}; It = speye(size(Et, 2));
            EEFt{t} = (rho/TaskNum*(Et'*Et)+C3/TaskNum*It)\(Ft');
            FFEt{t} = (lambda/TaskNum*(Ft'*Ft)+C4/TaskNum*It)\(Et');
            P = blkdiag(P, Ft*EEFt{t});
            S = blkdiag(S, Et*FFEt{t});
        end
    end

    function [ Alpha, Gamma ] = Primal(Q, P, R, S, e1, e2, m1, m2, opts)
        Sym = @(H) (H+H')/2;
        Alpha = quadprog(Sym(Q + P),-e2,[],[],[],[],zeros(m2, 1),opts.C1*e2,[],opts.solver);
        Gamma = quadprog(Sym(R + S),-e1,[],[],[],[],zeros(m1, 1),opts.C2*e1,[],opts.solver);
    end

    function [ U, V ] = GetWeight(Alpha, Gamma, EEF, FFE, EEFt, FFEt, N, TaskNum)
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = u - EEFt{t}*CAlpha{t};
            V{t} = v + FFEt{t}*CGamma{t};
        end
    end

    function [ yTest ] = Predict(xTest, X, TaskNum, U, V, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            At = xTest{t};
            [m, ~] = size(At);
            et = ones(m, 1);
            KAt = [Kernel(At, X, opts.kernel) et];
            D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
            D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
            yt = sign(D2-D1);
            yt(yt==0) = 1;
            yTest{t} = yt;
        end
    end

end