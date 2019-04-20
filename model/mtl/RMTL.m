function [ yTest, Time, Alpha ] = RMTL( xTrain, yTrain, xTest, opts )
%RMTL �˴���ʾ�йش˺�����ժҪ
% Regularized MTL
%   �˴���ʾ��ϸ˵��

%% Parse opts
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
mu = 1/(2*lambda2);
nu = TaskNum/(2*lambda1);
symmetric = @(H) (H+H')/2;
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);

%% Prepare
tic;
Q = Y.*Kernel(X, X, kernel).*Y';
P = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    P{t} = Q(Tt,Tt);
end
% ���ι滮���
lb = zeros(size(Y));
e = ones(size(Y));
H = Cond(mu*Q + nu*spblkdiag(P{:}));
[ Alpha ] = quadprog(symmetric(H), -e, [], [], [], [], lb, e, [], solver);
% ֹͣ��ʱ
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = predict(Ht, Y, Alpha);
    yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
    y = sign(mu*y0 + nu*yt);
    y(y==0) = 1;
    yTest{t} = y;
end

    function [ y ] = predict(H, Y, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
    end
end