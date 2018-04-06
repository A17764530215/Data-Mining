function [ yTest, Time ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% Parse opts
    lambda = opts.lambda;
    mu = opts.mu;
    
%% Fit    
    [ T, ~ ] = size(xTrain);
    A = xTrain;
    Y = yTrain;
    e = ones(size(yTrain));
    P = [];
    for i = 1 : T
        Pt = At*At'+et*et'+(lambda/T*mu);
        P = blkdiag(P, Pt);
    end
    
    Alpha = (A'*A+T/lambda*P)'*Y;
end