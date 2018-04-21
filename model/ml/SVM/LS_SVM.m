function [ yTest, Time ] = LS_SVM( xTrain, yTrain, xTest, opts )
%LS_SVR �˴���ʾ�йش˺�����ժҪ
% Least Square Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    gamma = opts.gamma;
    kernel = opts.kernel;

%% Fit
    tic;
    X = xTrain;
    Y = yTrain;
    Z = Kernel(X, X, kernel);
    E = ones(size(Y));
    I = sparse(diag(E));
    H = Z*Z' + 1/gamma*I;
    A = [H Y;Y' 0];
    b = [E; 0];
    w = A\b;
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    yTest = sign([Kernel(xTest, X, kernel) ones(m, 1)]*w);
    
end

