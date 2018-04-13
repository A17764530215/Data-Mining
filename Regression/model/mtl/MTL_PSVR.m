function [ yTest, Time, W ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR �˴���ʾ�йش˺�����ժҪ
% Multi-task proximal support vector machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    lambda = opts.lambda;
    nu = opts.nu;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    rate = TaskNum/lambda;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    C = A; % �����˱任����
    A = Kernel(A, C, kernel); % �����Ա任
    
%% Fit
    e = cell(TaskNum);
    P = [];
    for t = 1 : TaskNum
        Tt = T==t;
        At = A(Tt,:);
        et = ones(size(Y(Tt,:)));
        Pt = At*At'+et*et'+1/(nu*rate);
        P = blkdiag(P, Pt);
        e{t} = et;
    end
    H = (A'*A+rate*P);
    H = Utils.Cond(H);
    Alpha = H\Y;
    
%% Get W
    W = cell(TaskNum, 1);
    W0 = A'*Alpha;
    for t = 1 : TaskNum
        Tt = T==t;
        A_t = A(Tt,:);
        Alpha_t = Alpha(Tt,:);
        Wt = W0 + rate*A_t'*Alpha_t;
        Gamma = -rate*Alpha_t'*e{t};
        W{t} = [Wt; Gamma];
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = xTest{t};
        [m, ~] = size(At);
        et = ones(m, 1);
        KAt = [Kernel(At, C, kernel) et];
        yTest{t} = KAt * W{t};
    end
    
end