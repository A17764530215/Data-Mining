function [ yTest, Time ] = IRMTL( xTrain, yTrain, xTest, opts )
%IRMTL �˴���ʾ�йش˺�����ժҪ
% Regularized MTL
%   �˴���ʾ��ϸ˵��

%% Parse opts
C = opts.C;
mu = opts.mu;
kernel = opts.kernel;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;

%% Prepare
tic;
% �õ����е������ͱ�ǩ�Լ�������
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
X = [X, ones(size(Y))];
Q = Y.*Kernel(X, X, kernel).*Y';
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
end
% ���ι滮���
e = ones(size(Y));
lb = zeros(size(Y));
H = Cond(Q/mu + P);
[ Alpha ] = quadprog(symmetric(H), -e, [], [], [], [], lb, C*e, [], []);
% ֹͣ��ʱ
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = find(T==t);
    et = ones(size(xTest{t}, 1), 1);
    Ht = Kernel([xTest{t}, et], X, kernel);
    y0 = predict(Ht, Y, Alpha);
    yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
    y = sign(y0/mu + yt);
    y(y==0) = 1;
    yTest{t} = y;
end

    function [ y ] = predict(H, Y, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
    end

end

