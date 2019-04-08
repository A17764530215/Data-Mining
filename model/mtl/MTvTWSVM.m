function [ yTest, Time ] = MTvTWSVM( xTrain, yTrain, xTest, opts )
%MTVTWSVM 此处显示有关此函数的摘要
% Multi-Task $\nu$-Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
v1 = opts.v1;
v2 = opts.v1;
mu1 = opts.rho;
mu2 = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;
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
EEF = Cond(E'*E)\F';
FFE = Cond(F'*F)\E';
Q = F*EEF; R = E*FFE;
% 得到P,S矩阵
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
EEFc = cell(TaskNum, 1);
FFEc = cell(TaskNum, 1);
P = cell(TaskNum, 1);
S = cell(TaskNum, 1);
for t = 1 : TaskNum
    Et = Ec{t}; Ft = Fc{t};
    EEFc{t} = Cond(Et'*Et)\(Ft');
    FFEc{t} = Cond(Ft'*Ft)\(Et');
    P{t} = Ft*EEFc{t};
    S{t} = Et*FFEc{t};
end
P = spblkdiag(P{:});
S = spblkdiag(S{:});

%% Fit
% MTL_TWSVR1_Xie
H1 = Q + TaskNum/mu1*P;
Alpha = quadprog(symmetric(H1),[],-e2',-v1,[],[],zeros(m2, 1),e2/m2,[],solver);
% MTL_TWSVR2_Xie
H2 = R + TaskNum/mu2*S;
Gamma = quadprog(symmetric(H2),[],-e1',-v2,[],[],zeros(m1, 1),e1/m1,[],solver);

%% GetWeight
CAlpha = mat2cell(Alpha, N(2,:));
CGamma = mat2cell(Gamma, N(1,:));
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - EEFc{t}*(TaskNum/mu1*CAlpha{t});
    V{t} = v + FFEc{t}*(TaskNum/mu2*CGamma{t});
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