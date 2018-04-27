function [ yTest, Time ] = PSVR( xTrain, yTrain, xTest, opts )
%PSVR �˴���ʾ�йش˺�����ժҪ
% Proximal Support Vector Regression
%   �˴���ʾ��ϸ˵��

%% Parse opts
nu = opts.nu;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
H = Kernel(X, X, kernel);
I = speye(size(H));
Alpha = Cond(H + 1 + 1/nu*I)\Y;
svi = (Alpha>0)&(Alpha<nu);
b = sum(Alpha(svi));
Time = toc;

%% Predict
yTest = Kernel(xTest, X(svi,:), kernel)*Alpha(svi,:)+b;

end