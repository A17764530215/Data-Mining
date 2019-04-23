function [ yTest, Time ] = DMTSVM( xTrain, yTrain, xTest, opts )
%DMTSVM 此处显示有关此函数的摘要
% Multi-Task Twin Support Vector Machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);

tic;
[ Q, P, R, S, EEF, FFE, EEFc, FFEc ] = Prepare(X, Y, N, opts);
[ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts);
[ Alpha, Gamma ] = Primal(H1, H2, e1, e2, opts);
Time = toc;

[ U, V ] = GetWeight(EEF, FFE, EEFc, FFEc, Alpha, Gamma, N, TaskNum, opts);
[ yTest ] = Predict(xTest, X, TaskNum, U, V);

    function [ H1, H2 ] = GetHessian(Q, P, R, S, TaskNum, opts)
        Sym = @(H) (H+H')/2 + 1e-5*speye(size(H));
        H1 = Sym(Q + TaskNum/opts.rho*P);
        H2 = Sym(R + TaskNum/opts.rho*S);
    end

    function [ Alpha, Gamma ] = Primal(H1, H2, e1, e2, opts)
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
            V{t} = v + FFEc{t}*(TaskNum/opts.lambda*CGamma{t});
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