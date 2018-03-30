function [ yTest, Time ] = MTL_TWSVR(xTrain, yTrain, xTest, opts)
%MTL_TWSVR �˴���ʾ�йش����ժҪ
% Multi-Task Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    C1 = opts.C1;         % ����1
    C2 = opts.C2;         % ����2
    eps1 = opts.eps1;     % ����3
    eps2 = opts.eps2;     % ����4
    kernel = opts.Kernel; % �˺�������

%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ TaskNum, ~ ] = size(xTrain);  
    A = []; Y = []; T = [];
    for t = 1 : TaskNum
        % �õ�����i��H����
        Xt = xTrain{t};
        A = cat(1, A, Xt);
        % �õ�����i��Y����
        Yt = yTrain{t};
        Y = cat(1, Y, Yt);
        % ���������±�
        [m, ~] = size(Yt);
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A; % �����˱任����
    A = [Kernel(A, C, kernel) e]; % �����Ա任
    % �õ�f��g
    f = Y + eps2;
    g = Y - eps1;
    % �õ�P����
    P = [];
    TaskNum = 5;
    Rts = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        Rts{t} = (At'*At)\At';
        Pt = At*Rts{t};
        P = blkdiag(P, Pt);
    end
    % ���ι滮��H����
    H = (A/(A'*A))*A' + P;
    %% Fit
    % ����������ι滮
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    H = Utils.Cond(H);
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H,g-H'*f,[],[],[],[],lb,ub1,[]);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H,H'*g-f,[],[],[],[],lb,ub2,[]);

%% GetWeight
    W = cell(TaskNum, 1);
    U = (A'*A)\A'*(f - Alpha);
    V = (A'*A)\A'*(g + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = Rts{t}*(f(Tt,:) - Alpha(Tt,:));
        Vt = Rts{t}*(g(Tt,:) + Gamma(Tt,:));
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
        KAte = [Kernel(At, C, opts.Kernel) et];
        yTest{t} = KAte * W{t};
    end

end