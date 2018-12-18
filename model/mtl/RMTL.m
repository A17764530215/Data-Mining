function [ yTest, Time ] = RMTL( xTrain, yTrain, xTest, opts )
%RMTL �˴���ʾ�йش˺�����ժҪ
% Regularized MTL
%   �˴���ʾ��ϸ˵��

%% Parse opts
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;
kernel = opts.kernel;
TaskNum = length(xTrain);

mu = 1/(2*lambda2);
nu = TaskNum/(2*lambda1);

%% Prepare
tic;
% �õ����е������ͱ�ǩ�Լ�������
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
Q = Y.*Kernel(X, X, kernel).*Y;
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
end
% ���ι滮���
lb = zeros(size(Y));
e = ones(size(Y));
H = Cond(mu*Q + nu*P);
[ Alpha ] = quadprog(H, -e, [], [], [], [], lb, e, [], []);
% ֹͣ��ʱ
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = mu*Predict(Ht, Y, Alpha);
    yt = nu*Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
    y = sign(mu*y0 + nu*yt);
    y(y==0) = 1;
    yTest{t} = y;
end

    function [ y ] = Predict(H, Y, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
    end

end