function [ yTest, Time ] = MTCTSVM( xTrain, yTrain, xTest, opts )
%MTCTSVM �˴���ʾ�йش˺�����ժҪ
% Multi-Task Centroid Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;

%% Prepare
tic;
% �õ����е������ͱ�ǩ�Լ�������
[ X, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
% �ָ��������
Yp = Y==1;
Yn = Y==-1;
A = X(Yp,:);
B = X(Yn,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% �˺���
e1 = ones(m1, 1);
e2 = ones(m2, 1);
E = [Kernel(A, X, kernel) e1];
F = [Kernel(B, X, kernel) e2];
% �õ�Q,R����
EEF = Cond(E'*E)\F';
FFE = Cond(F'*F)\E';
Q = F*EEF;
R = E*FFE;
% �õ�P,S����
P = sparse(0, 0);
S = sparse(0, 0);
EEFt = cell(TaskNum, 1);
FFEt = cell(TaskNum, 1);
for t = 1 : TaskNum
    Et = E(T(Yp)==t,:);
    Ft = F(T(Yn)==t,:);
    EEFt{t} = Cond(Et'*Et)\(Ft');
    FFEt{t} = Cond(Ft'*Ft)\(Et');
    P = blkdiag(P, Ft*EEFt{t});
    S = blkdiag(S, Et*FFEt{t});
end

%% Fit
% ����������ι滮
% MTL_TWSVR1_Xie
H1 = Q + 1/rho*P;
Alpha = quadprog(symmetric(H1),-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
% MTL_TWSVR2_Xie
H2 = R + 1/lambda*S;
Gamma = quadprog(symmetric(H2),-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - 1/rho*EEFt{t}*Alpha(T(Yn)==t,:);
    V{t} = v + 1/lambda*FFEt{t}*Gamma(T(Yp)==t,:);
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
    D1 = abs(KAt * U{t});
    D2 = abs(KAt * V{t});
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end
end