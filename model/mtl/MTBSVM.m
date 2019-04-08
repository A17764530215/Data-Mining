function [ yTest, Time ] = MTBSVM( xTrain, yTrain, xTest, opts )
%MTBSVM 此处显示有关此函数的摘要
% Multi-task Twin Bounded Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
C3 = opts.C3;
C4 = opts.C3;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;

%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ X, Y, T, N ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
Yp = Y==1;
Yn = Y==-1;
A = X(Yp,:);
B = X(Yn,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
E = [Kernel(A, X, kernel) e1];
F = [Kernel(B, X, kernel) e2];
% 得到Q,R矩阵
I = speye(size(E, 2));
EE = E'*E; FF = F'*F;
EEF = (EE+C3*I)\F';
FFE = (FF+C4*I)\E';
Q = F*EEF;
R = E*FFE;
% 得到P,S矩阵
P = sparse(0, 0);
S = sparse(0, 0);
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
EEc = mat2cell(EE, N(1,:), N(1,:));
FFc = mat2cell(FF, N(2,:), N(2,:));
EEFc = cell(TaskNum, 1);
FFEc = cell(TaskNum, 1);
for t = 1 : TaskNum
    It = speye(size(Ec{t}, 2));
    EEFc{t} = (rho/TaskNum*EEc{t,t}+C3/TaskNum*It)\(Fc{t}');
    FFEc{t} = (lambda/TaskNum*FFc{t,t}+C4/TaskNum*It)\(Ec{t}');
    P = blkdiag(P, Fc{t}*EEFc{t});
    S = blkdiag(S, Ec{t}*FFEc{t});
end

%% Fit
% MTBSVM1
Alpha = quadprog(symmetric(Q + P),-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
CAlpha = mat2cell(Alpha, N(2,:));
% MTBSVM2
Gamma = quadprog(symmetric(R + S),-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);
CGamma = mat2cell(Gamma, N(1,:));

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - EEFc{t}*CAlpha{t};
    V{t} = v + FFEc{t}*CGamma{t};
end
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
parfor t = 1 : TaskNum
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