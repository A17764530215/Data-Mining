function [ yTest, Time ] = MTL_TWSVR_Xu( xTrain, yTrain, xTest, opts )
%MTL_TWSVR_XU �˴���ʾ�йش˺�����ժҪ
% K-nearest neighbor-based weighted twin support vector regression
% MTL Xu's model
%   �˴���ʾ��ϸ˵��

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C2;
    eps1 = opts.eps1;
    eps2 = opts.eps2;
    kernel = opts.Kernel;
    solver = opts.solver;
    
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
    
%% �õ�P����
    A = [Kernel(A, C, kernel) e]; % �����Ա任
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
    AA = A'*A;
    AA = Utils.Cond(AA);
    AAA = AA\A';
    H = A*AAA + P;
    
%% Fit
    % ����������ι滮
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    HTY = H'*Y;
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H,(Y+eps1)-HTY,[],[],[],[],lb,ub1,[],solver);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H,HTY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    
%% GetWeight
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = Rts{t}*(Y(Tt,:) - Alpha(Tt,:));
        Vt = Rts{t}*(Y(Tt,:) + Gamma(Tt,:));
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