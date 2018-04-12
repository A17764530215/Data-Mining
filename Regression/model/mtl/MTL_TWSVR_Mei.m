function [ yTest, Time, W ] = MTL_TWSVR_Mei( xTrain, yTrain, xTest, opts )
%MTL_TWSVR_MEI �˴���ʾ�йش˺�����ժҪ
% 2018��4��3��17:12:10
%   �˴���ʾ��ϸ˵��

%% Parse opts
    T = length(xTrain);
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    rho = T/opts.rho;
    lambda = T/opts.rho;
    kernel = opts.kernel;
    solver = opts.solver;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A; % �����˱任����
    A = [Kernel(A, C, kernel) e]; % �����Ա任
    
    %% �õ�Q,P����
    % �õ�Q����
    AA = A'*A;
    AA = Utils.Cond(AA);
    AAA = AA\A';
    Q = A*AAA;
    % �õ�P����
    P = [];
    AAAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        AAAt{t} = (At'*At)\At';
        Pt = At*AAAt{t};
        P = blkdiag(P, Pt);
    end
    
%% Fit
    % ����������ι滮
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    H1 = Q+rho*P;
    H2 = Q+lambda*P;
    QPY = (Q+P)'*Y;
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H1,(Y+eps1)-QPY,[],[],[],[],lb,ub1,[],solver);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H2, QPY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    
%% Get W
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = AAAt{t}*(Y(Tt,:) - rho*Alpha(Tt,:));
        Vt = AAAt{t}*(Y(Tt,:) + lambda*Gamma(Tt,:));
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
