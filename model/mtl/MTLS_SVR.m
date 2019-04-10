function  [ yTest, Time ] = MTLS_SVR(xTrain, yTrain, xTest, opts)
%MTL_LS_SVR 此处显示有关此函数的摘要
% Multi-task least-squares support vector regression
% ref:Multi-task least-squares support vector machines
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
A = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
    A = blkdiag(A, ones(sum(Tt), 1));
end
o = zeros(TaskNum, 1);
O = speye(TaskNum)*0;
I = speye(size(Q));
H = Q + TaskNum/lambda*P + I/C;
Alphab = [H A;A' O]\[Y; o];
Alpha = Alphab(1:end-TaskNum,:);
b = Alphab(end-TaskNum+1:end,:);
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = Predict(Ht, Alpha);
    yt = Predict(Ht(:,Tt), Alpha(Tt,:));
    yTest{t} = y0 + TaskNum/lambda * yt + b(t);
end

    function [ y ] = Predict(H, Alpha)
        svi = Alpha ~= 0;
        y = H(:,svi)*Alpha(svi);
    end
end
