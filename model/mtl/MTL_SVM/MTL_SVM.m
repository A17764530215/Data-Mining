function [ yTest ] = MTL_SVM( xTrain, yTrain, xTest, opts )
%MTL_SVM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    lambda1 = opts.lambda1;
    lambda2 = opts.lambda2;
    TaskNum = length(xTrain);
    
    C = TaskNum/(2*lambda1);
    mu = TaskNum*lambda2/lambda1;
    
%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ A, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    [m, ~] = size(A);
    Q = Kernel(A, A, kernel);
    P = [];
    for i = 1 : TaskNum
        P = blkdiag(P, Kernel(xTrain{t}, xTrain{t}, kernel));
    end
    % ���ι滮���
    H = diag(Y)*(mu/1*Q + P)*diag(Y);
    e = ones(m, 1);
    f = -e;
    lb = zeros(m, 1);
    ub = C*e;
    [ Alpha ] = quadprog(H, f, [], [], [], [], lb, ub, [], []);
    svi = Alpha > 0 & Alpha < C;
    % ֹͣ��ʱ
    Time = toc;
    
%% Fit


end