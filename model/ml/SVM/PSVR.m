function [ yTest, Time ] = PSVR( xTrain, yTrain, xTest, opts )
%PSVR �˴���ʾ�йش˺�����ժҪ
% Proximal Support Vector Regression
%   �˴���ʾ��ϸ˵��

%% Parse opts
C = opts.C;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
H = Kernel(X, X, kernel);
I = speye(size(H));
Alpha = Cond(H + 1 + I/C)\Y;
svi = Alpha~=0;
b = sum(Alpha(svi));
Time = toc;

%% Predict
yTest = Kernel(xTest, X(svi,:), kernel)*Alpha(svi,:)+b;

end