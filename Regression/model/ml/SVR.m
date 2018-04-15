function [ yTest, Time, W ] = SVR( xTrain, yTrain, xTest, opts )
%SVR �˴���ʾ�йش˺�����ժҪ
% Support Vector Regression
%   �˴���ʾ��ϸ˵��

    C = opts.C;
    eps = opts.eps;
    kernel = opts.kernel;
    solver = opts.solver;
    
%% Fit
    tic;
    A = xTrain;
    Y = yTrain;
    K = Kernel(A, A, kernel);
    H = [K -K;-K K];
    f = [-Y;Y]+eps;
    e = ones(size(Y));
    Aeq = diag([e;-e]);
    beq = zeros(size(f));
    lb = zeros(size(f));
    ub = C*ones(size(f));
    Beta = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],solver);
    n = length(Y);
    Alpha = reshape(Beta, n, 2);
    alpha = Alpha(:,1)-Alpha(:,2);
    % Support Vectors
    idx = alpha > 0;
    w = alpha(idx,:);
    sv = A(idx,:);
    % calculate b
    b = mean(Y - Kernel(sv, sv, kernel)*w);
    W = [w; b];
    Time = toc;
    
%% Predict
    yTest = Kernel(xTest, sv, kernel)*w + b;
    
end