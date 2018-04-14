function [ yTest, Time, w ] = TWSVR( xTrain, yTrain, xTest, opts )
%TWSVR �˴���ʾ�йش����ժҪ
% Twin Support Vector Machine
% see: Improvements on Twin Support Vector Machines
% see: TWSVR: Regression via Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    C3 = opts.C3;
    C4 = opts.C3;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    kernel = opts.kernel;
    solver = opts.solver;
    
%% Fit
    tic;
    % �õ�H
    e = ones(size(yTrain));
    C = xTrain;
    H = [Kernel(xTrain, C, kernel) e];
    % �õ�f,g
    f = yTrain + eps2;
    g = yTrain - eps1;
    % �õ�Hu,Hv
    H2 = H'*H;
    I = eye(size(H2));
    Hu = (H2+C3*I)\H';
    Hv = (H2+C4*I)\H';
    % �õ�Q1��Q2
    Q1 = H*Hu;
    Q2 = H*Hv;
    % ����������ι滮
    [m, ~] = size(yTrain);
    e = ones(m, 1);
    lb = zeros(m, 1);
    % TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(-Q1,Q1'*f-g,[],[],[],[],lb,ub1,[],solver);
    % TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(-Q2,f-Q2'*g,[],[],[],[],lb,ub2,[],solver);
    % �õ�u,v
    u = Hu*(f-Alpha);
    v = Hv*(g+Gamma);
    % �õ�w
    w = (u+v)/2;
    % ֹͣ��ʱ
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    e = ones(m, 1);
    yTest = [Kernel(xTest, C, kernel), e]*w;
    
end