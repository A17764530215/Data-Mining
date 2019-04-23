function [ yTest, Time ] = MTPSVM( xTrain, yTrain, xTest, opts )
%MTPSVM 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
% ref:Multi-task proximal support vector machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );

tic;
[ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, opts);
[ Alpha ] = Primal(Q, P, I, E, TaskNum, opts);
Time = toc;

[ yTest ] = Predict(xTest, X, Y, T, TaskNum, Alpha, opts);

    function [ Q, P, I, E ] = Prepare(X, Y, T, TaskNum, opts
        H = Kernel(X, X, opts.kernel);
        Q = Y.*H.*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            y = Y(Tt,:);
            P = blkdiag(P, y.*(H(Tt,Tt) + 1).*y');
        end
        I = speye(size(Q));
        E = ones(size(Y));
    end

    function [ Alpha ] = Primal(Q, P, I, E, TaskNum, opts)
        Alpha = Cond(Q + TaskNum/opts.lambda*P + I/opts.C)\E;
    end

    function [ yTest ] = Predict(xTest, X, Y, T, TaskNum, Alpha, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = Predict(Ht, Y, Alpha);
            yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            bt = TaskNum/opts.lambda*Y(Tt,:)'*Alpha(Tt,:);
            y = sign(y0 + TaskNum/opts.lambda * yt + bt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
            function [ y ] = Predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end

end