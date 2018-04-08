function [ yTest, Time ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR �˴���ʾ�йش˺�����ժҪ
% Multi-task proximal support vector machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
    lambda = opts.lambda;
    mu = opts.mu;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Fit
    A = xTrain;
    Y = yTrain;
    e = ones(size(yTrain));
    P = [];
    for i = 1 : TaskNum
        Pt = At*At'+et*et'+(lambda/TaskNum*mu);
        P = blkdiag(P, Pt);
    end
    
    Alpha = (A'*A+TaskNum/lambda*P)'*Y;
end