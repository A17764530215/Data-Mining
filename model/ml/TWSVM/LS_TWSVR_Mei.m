function [ yTest, Time ] = LS_TWSVR_Mei(xTrain, yTrain, xTest, opts)
%LS_TWSVR �˴���ʾ�йش˺�����ժҪ
% Least Square Twin Support Vector Regression
% Derived from TWSVR via TWSVM
%   �˴���ʾ��ϸ˵��

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    kernel = opts.kernel;
    
%% Prepare
    tic;
    A = xTrain;
    Y = yTrain;
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A;
    A = [Kernel(A, C, kernel) e];
    % �õ�f��g
    f = Y + eps2;
    g = Y - eps1;
    % �õ�Q����
    AAA = Cond(A'*A)\A';
    H = A*AAA;

%% Fit
    I = eye(size(H));
    % LS-TWSVR1
    L1 = H - 1/C1*I;
    R1 = g - H*f;
    Alpha = L1\R1;
    % LS-TWSVR2
    L2 = 1/C2*I - H;
    R2 = f - H*g;
    Gamma = L2\R2;
    % �õ�u,v
    u = AAA*(f+Alpha);
    v = AAA*(g-Gamma);
    % �õ�w
    w = (u+v)/2;
    % ֹͣ��ʱ
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    e = ones(m, 1);
    yTest = [Kernel(xTest, C, kernel), e]*w;
    
end

