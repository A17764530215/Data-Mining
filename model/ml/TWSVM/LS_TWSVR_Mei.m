function [ yTest, Time ] = LS_TWSVR_Mei(xTrain, yTrain, xTest, opts)
%LS_TWSVR �˴���ʾ�йش˺�����ժҪ
% Least Square Twin Support Vector Regression
% Derived from TWSVR via TWSVM
%   �˴���ʾ��ϸ˵��

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
eps1 = opts.eps1;
eps2 = opts.eps1;
kernel = opts.kernel;

%% Prepare
tic;
A = xTrain;
Y = yTrain;
[m, ~] = size(A);
e = ones(m, 1);
C = A;
A = [Kernel(A, C, kernel) e];
% �õ�f��g
f = Y + eps2;
g = Y - eps1;
% �õ�Q����
AAA = Cond(A'*A)\A';
H = A*AAA;

%% Fit
I = speye(size(H));
Alpha = Cond(H - 1/C1*I)\(g - H*f);
Gamma = Cond(1/C2*I - H)\(f - H*g);
% �õ�u,v
u = AAA*(f+Alpha);
v = AAA*(g-Gamma);
% �õ�w
w = (u+v)/2;
% ֹͣ��ʱ
Time = toc;

%% Predict
[m, ~] = size(xTest);
e = ones(m, 1);
yTest = [Kernel(xTest, C, kernel), e]*w;

end
