function [ yTest, Time ] = MTLS_TWSVM(xTrain, yTrain, xTest, opts)
%MTLS_TWSVM 此处显示有关此函数的摘要
% Multi-Task Least Square Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
TaskNum = length(xTrain);
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);

%% Prepare
tic;
% 分割正负类点
A = X(Y==1,:);
B = X(Y==-1,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
E = [Kernel(A, X, kernel) e1];
F = [Kernel(B, X, kernel) e2];
% 得到Q,R矩阵
EE = Cond(E'*E); FF = Cond(F'*F);
EEF = EE\F'; FFE = FF\E';
Q = F*EEF; R = E*FFE;
% 得到P矩阵
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
EEc = mat2cell(EE, N(1,:), N(1,:));
FFc = mat2cell(FF, N(2,:), N(2,:));
EEFc = cell(TaskNum, 1);
FFEc = cell(TaskNum, 1);
P = sparse(0, 0);
S = sparse(0, 0);
for t = 1 : TaskNum
    EEFc{t} = EEc{t,t}\(Fc{t}');
    FFEc{t} = FFc{t,t}\(Ec{t}');
    P = blkdiag(P, Fc{t}*EEFc{t});
    S = blkdiag(S, Ec{t}*FFEc{t});
end

%% Fit
% MTL-LS-TWSVM1
I = speye(size(Q));
Alpha = Cond(Q + TaskNum/rho*P + 1/C1*I)\e2;
CAlpha = mat2cell(Alpha, N(2,:));
% MTL-LS-TWSVM2
I = speye(size(R));
Gamma = Cond(R + TaskNum/lambda*S + 1/C2*I)\e1;
CGamma = mat2cell(Gamma, N(1,:));

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - EEFc{t}*(TaskNum/rho*CAlpha{t});
    V{t} = v + FFEc{t}*(TaskNum/lambda*CGamma{t});
end
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = xTest{t};
    [m, ~] = size(At);
    et = ones(m, 1);
    KAt = [Kernel(At, X, kernel) et];
    D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
    D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end