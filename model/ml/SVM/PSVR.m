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
C = X;
Z = Kernel(X, C, kernel);
e = ones(size(Y));
alpha = Cond(Z*Z'+1+1/nu*speye(size(Z)))\Y;
w = Z'*alpha;
xi = alpha/nu;
gamma = -e'*alpha;
Time = toc;

%% Predict
yTest = Kernel(xTest, C, kernel)*w-gamma;

end
