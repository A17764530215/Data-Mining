function [ yTest, Time ] = MTBSVM( xTrain, yTrain, xTest, opts )
%MTBSVM �˴���ʾ�йش˺�����ժҪ
% Multi-task Twin Bounded Support Vector Machine
%   �˴���ʾ��ϸ˵��

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
I = speye(size(E, 2));
EEF = (E'*E+C3*I)\F';
FFE = (F'*F+C4*I)\E';
Q = F*EEF;
R = E*FFE;
% �õ�P,S����
P = sparse(0, 0);
S = sparse(0, 0);
EEFt = cell(TaskNum, 1);
FFEt = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tpt = T(Yp)==t;
    Tpn = T(Yn)==t;
    Et = E(Tpt,:);
    Ft = F(Tpn,:);
    It = speye(size(Et, 2));
    EEFt{t} = (rho/TaskNum*(Et'*Et)+C3/TaskNum*It)\(Ft');
    FFEt{t} = (lambda/TaskNum*(Ft'*Ft)+C4/TaskNum*It)\(Et');
    P = blkdiag(P, Ft*EEFt{t});
    S = blkdiag(S, Et*FFEt{t});
end

%% Fit
% ����������ι滮
% MTBSVM1
Alpha = quadprog(symmetric(Q + P),-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
% MTBSVM2
Gamma = quadprog(symmetric(R + S),-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - EEFt{t}*Alpha(T(Yn)==t,:);
    V{t} = v + FFEt{t}*Gamma(T(Yp)==t,:);
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