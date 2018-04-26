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
K = Kernel(X, X, kernel);
I = speye(size(K));
DY = I.*Y;
H = DY*K*DY + 1/gamma*I;
E = ones(size(Y));
Alphab = [0 Y';Y H]\[0; E];
b = Alphab(1);
Alpha = Alphab(2:end);
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X, kernel)*(Alpha.*Y) + b);

end