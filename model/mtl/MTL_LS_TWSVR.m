function [ yTest, Time ] = MTL_LS_TWSVR(xTrain, yTrain, xTest, opts)
%MTL_LS_TWSVR �˴���ʾ�йش˺�����ժҪ
% Multi-Task Least Square Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
eps1 = opts.eps1;
eps2 = opts.eps1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
TaskNum = length(xTrain);

%% Prepare
tic;
% �õ����е������ͱ�ǩ�Լ�������
[ A, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
[m, ~] = size(A);
e = ones(m, 1);
C = A;
A = [Kernel(A, C, kernel) e];
% �õ�f��g
f = Y + eps2;
g = Y - eps1;
% �õ�Q����
AAA = Cond(A'*A)\A';
Q = A*AAA;
% �õ�P����
P = sparse(0, 0);
AAAt = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = A(T==t,:);
    AAAt{t} = Cond(At'*At)\(At');
    Pt = At*AAAt{t};
    P = blkdiag(P, Pt);
end
% �õ�H����
H = Q + P;

%% Fit
% ����������Է���
I = speye(size(H));
% MTL-LS-TWSVR1
L1 = Q + TaskNum/rho*P - 1/C1*I;
R1 = g - H*f;
Alpha = L1\R1;
% MTL-LS-TWSVR2
L2 = 1/C2*I - Q - TaskNum/lambda*P;
R2 = f - H*g;
Gamma = L2\R2;

%% GetWeight
W = cell(TaskNum, 1);
U = AAA*(Y + Alpha);
V = AAA*(Y - Gamma);
for t = 1 : TaskNum
    Tt = T==t;
    Ut = AAAt{t}*(Y(Tt,:) + TaskNum/rho*Alpha(Tt,:));
    Vt = AAAt{t}*(Y(Tt,:) - TaskNum/lambda*Gamma(Tt,:));
    Uts = U + Ut;
    Vts = V + Vt;
    W{t} = (Uts + Vts)/2;
end
Time = toc;

%% Predict
[ TaskNum, ~ ] = size(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = xTest{t};
    [m, ~] = size(At);
    et = ones(m, 1);
    KAt = [Kernel(At, C, kernel) et];
    yTest{t} = KAt * W{t};
end

end