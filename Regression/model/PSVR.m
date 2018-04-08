function [ yTest, Time ] = PSVR( xTrain, yTrain, xTest, opts )
%PSVR �˴���ʾ�йش˺�����ժҪ
% Proximal Support Vector Regression
%   �˴���ʾ��ϸ˵��

%% Parse opts
    nu = opts.nu;
    kernel = opts.kernel;
    
%% Fit
    tic;
    A = xTrain;
    Y = yTrain;
    C = A;
    A = Kernel(A, C, kernel);
    e = ones(size(Y));
    alpha = (A*A'+1+1/nu)\Y;
    w = A'*alpha;
    xi = alpha/nu;
    gamma = -e'*alpha;
    Time = toc;
    
%% Predict
    B = xTest;
    B = Kernel(B, C, kernel);
    Y = B*w-gamma;
    yTest = Y;
    
end
