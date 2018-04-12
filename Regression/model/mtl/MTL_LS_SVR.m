function  [ yTest, Time, W ] = MTL_LS_SVR(xTrain, yTrain, xTest, opts)
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
        Tt = T==t;
        At = A(Tt,:);
        B = blkdiag(B, At*At');
        E = blkdiag(E, ones(sum(Tt),1));
    end
    o = zeros(TaskNum, 1);
    O = diag(o);
    I = diag(ones(size(Y)));
    H = A*A' + 1/gamma*I + TaskNum/lambda*B;
    X = [O E';E H]\[o; Y];
    D = X(1:TaskNum,:);
    Alpha = X(TaskNum+1:end,:);
    
%% Get W
    W0 = A'*Alpha;
    W = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        W{t} = W0 + (TaskNum/lambda)*A(Tt,:)'*Alpha(Tt,:);
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        KAt = Kernel(xTest{t}, C, kernel);
        yTest{t} = KAt * W{t} + D(t);
    end
    
end
