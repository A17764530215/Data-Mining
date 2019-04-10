function [ yTest, Time ] = LS_SVM( xTrain, yTrain, xTest, opts )
%LS_SVR 此处显示有关此函数的摘要
% Least Square Support Vector Machine
%   此处显示详细说明

%% Parse opts
C = opts.C;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
Q = Y.*Kernel(X, X, kernel).*Y';
I = speye(size(Q));
H = Q + I/C;
E = ones(size(Y));
Alphab = [H Y;Y' 0]\[E; 0];
Alpha = Alphab(1:end-1);
svi = Alpha~=0;
b = Alphab(end);
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:)) + b);

end