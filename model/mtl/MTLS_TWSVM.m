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
[ C, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);

%% Prepare
tic;
% 分割正负类点
Yp = Y==1;
Yn = Y==-1;
A = C(Yp,:);
B = C(Yn,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
A = [Kernel(A, C, kernel) e1];
B = [Kernel(B, C, kernel) e2];
% 得到Q,R矩阵
AAB = Cond(A'*A)\B';
BBA = Cond(B'*B)\A';
Q = B*AAB; R = A*BBA;
% 得到P,S矩阵
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
AABt = cell(TaskNum, 1);
BBAt = cell(TaskNum, 1);
P = sparse(0, 0);
S = sparse(0, 0);
for i = 1 : TaskNum
    Et = Ec{i}; Ft = Fc{i};
    AABt{i} = Cond(Et'*Et)\(Ft');
    BBAt{i} = Cond(Ft'*Ft)\(Et');
    P = blkdiag(P, Ft*AABt{i});
    S = blkdiag(S, Et*BBAt{i});
end

%% Fit
% MTL-LS-TWSVM1
I = speye(size(Q));
Alpha = Cond(Q + TaskNum/rho*P + 1/C1*I)\e2;
% MTL-LS-TWSVM2
I = speye(size(R));
Gamma = Cond(R + TaskNum/lambda*S + 1/C2*I)\e1;

%% GetWeight
CAlpha = mat2cell(Alpha, N(2,:));
CGamma = mat2cell(Gamma, N(1,:));
u = -AAB*Alpha;
v = BBA*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u-AABt{t}*(TaskNum/rho*CAlpha{t});
    V{t} = v+BBAt{t}*(TaskNum/lambda*CGamma{t});
end
Time = toc;

%% Predict
[ TaskNum, ~ ] = size(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Et = xTest{t};
    [m, ~] = size(Et);
    et = ones(m, 1);
    KAt = [Kernel(Et, C, kernel) et];
    D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
    D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end