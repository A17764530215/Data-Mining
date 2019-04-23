function  [ yTest, Time ] = MTLS_SVM(xTrain, yTrain, xTest, opts)
%MTLS_SVM 此处显示有关此函数的摘要
% Multi-task least-squares support vector machines
% ref:Multi-task least-squares support vector machines
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );

tic;
[ Q, P ] = Prepare(X, Y, T, TaskNum, opts);
[ Alpha, b ] = Primal(Q, P, TaskNum, opts);
Time = toc;

[ yTest ] = Predict(xTest, X, Y, TaskNum, T, Alpha, b, opts);

    function  [ Q, P ] = Prepare(X, Y, T, TaskNum, opts)
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = sparse(0, 0);
        A = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
            A = blkdiag(A, Y(Tt,:));
        end
    end

    function [ Alpha, b ] = Primal(Q, P, TaskNum, opts)
        o = zeros(TaskNum, 1);
        O = speye(TaskNum)*0;
        I = speye(size(Q));
        E = ones(size(Q, 1));
        H = Q + TaskNum/opts.lambda*P + I/opts.C;
        G = [O A';A H];
        y = [o; E];
        bAlpha = G\y;
        Alpha = bAlpha(TaskNum+1:end,:);
        b = bAlpha(1:TaskNum,:);        
    end

    function [ yTest ] = Predict(xTest, X, Y, TaskNum, T, Alpha, b, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = Predict(Ht, Y, Alpha);
            yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(y0 + TaskNum/opts.lambda*yt + b(t));
            y(y==0) = 1;
            yTest{t} = y;
        end

            function [ y ] = Predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi).*Alpha(svi));
            end
    end

end
