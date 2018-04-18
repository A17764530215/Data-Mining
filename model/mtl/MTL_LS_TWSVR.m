function [ yTest, Time, W ] = MTL_LS_TWSVR(xTrain, yTrain, xTest, opts)
%MTL_LS_TWSVR �˴���ʾ�йش˺�����ժҪ
% Multi-Task Least Square Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    rho = opts.rho;
    lambda = opts.rho;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ A, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A;
    A = [Kernel(A, C, kernel) e];
    % �õ�Q����
    AAA = Cond(A'*A)\A';
    Q = A*AAA;
    % �õ�P����
    P = [];
    AAAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        AAAt{t} = Cond(At'*At)\(At');
        Pt = At*AAAt{t};
        P = blkdiag(P, Pt);
    end
    
%% Fit
    % ����������Է���
    I = eye(size(Q));
    e = ones(size(Y));
    % MTL-LS-TWSVR1
    H = Q + P - I;
    R1 = H*Y - eps1*e;
    L1 = (Q + TaskNum/rho*P + 1/C1*I);
    Alpha = L1\R1;
    % MTL-LS-TWSVR2
    H = -H;
    R2 = H*Y - eps2*e;
    L2 = (Q + TaskNum/lambda*P + 1/C2*I);
    Gamma = L2\R2;
    
%% GetWeight
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = AAAt{t}*(Y(Tt,:) - Alpha(Tt,:));
        Vt = AAAt{t}*(Y(Tt,:) + Gamma(Tt,:));
        Uts = U + Ut;
        Vts = V + Vt;
        W{t} = (Uts + Vts)/2;
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