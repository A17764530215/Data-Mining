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
A = Kernel(X, X, kernel);
e = ones(size(Y));
H = A*A^T + 1;
I = speye(size(H));
Alpha = Cond(H + 1/nu*I)\Y;

%% Get w,b
w = A'*Alpha;
b = e'*Alpha;
Time = toc;

%% Predict
yTest = Kernel(xTest, X, kernel)*w+b;

end
