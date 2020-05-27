function [ yTest, Time ] = MTPSVR( xTrain, yTrain, xTest, opts )
%MTPSVR 此处显示有关此函数的摘要
% Multi-task proximal support vector regression
% ref:Multi-task proximal support vector machine
%   此处显示详细说明

%% Parse opts
C = opts.C;
lambda = opts.lambda;
kernel = opts.kernel;
TaskNum = length(xTrain);
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );

%% Fit
tic;
Q = Kernel(X, X, kernel);
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt) + 1);
end
I = speye(size(Q));
Alpha = Cond(Q + TaskNum/lambda*P + I/C)\Y;
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = Predict(Ht, Alpha);
    yt = Predict(Ht(:,Tt), Alpha(Tt,:));
    bt = TaskNum/lambda * sum(Alpha(Tt,:));
    yTest{t} = y0 + TaskNum/lambda * yt + bt;
end

    function [ y ] = Predict(H, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*Alpha(svi,:);
    end
end