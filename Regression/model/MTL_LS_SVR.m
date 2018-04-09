function  [ yTest, Time ] = MTL_LS_SVR(xTrain, yTrain, xTest, opts)
%MTL_LS_SVR �˴���ʾ�йش˺�����ժҪ
% Multi-task least-squares support vector machines
%   �˴���ʾ��ϸ˵��

%% Parse opts
    lambda = opts.lambda;
    gamma = opts.gamma;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    C = A; % �����˱任����
    A = Kernel(A, C, kernel); % �����Ա任
    
%% Fit
    B = [];
    E = [];
    for t = 1 : TaskNum
        At = A(T==t,:);
        B = blkdiag(B, At*At');
        E = blkdiag(E, ones(size(Y(T==t,:))));
    end
    z = zeros(TaskNum, 1);
    Z = diag(z);
    O = A*A';
    I = diag(ones(size(Y)));
    H = O + TaskNum/lambda*B + 1/gamma*I;
    G = [Z E';E H];
    P = [z; Y];
    D = G\P;
    B = D(1:TaskNum,:);
    Alpha = D(TaskNum+1:end,:);
    
%% Get W
    W0 = A'*Alpha;
    W = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        Wt = W0 + (TaskNum/lambda)*A(Tt,:)'*Alpha(Tt,:);
        W{t} = [Wt; B(t)];
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
