function [ yTest, Time ] = MTvTWSVM( xTrain, yTrain, xTest, opts )
%MTVTWSVM �˴���ʾ�йش˺�����ժҪ
% Multi-Task $\nu$-Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
v1 = opts.v1;
v2 = opts.v1;
mu1 = opts.rho;
mu2 = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;
    
%% Prepare
tic;
% �õ����е������ͱ�ǩ�Լ�������
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
% �ָ��������
A = X(Y==1,:);
B = X(Y==-1,:);
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
% ���л�����
EEFc = cell(TaskNum, 1);
FFEc = cell(TaskNum, 1);
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
if isfield(solver, 'parallel')
    parfor t = 1 : TaskNum
        EEFc{t} = Cond(Ec{t}'*Ec{t})\(Fc{t}');
        FFEc{t} = Cond(Fc{t}'*Fc{t})\(Ec{t}');
    end
    solver = rmfield(solver, 'parallel');
else
    for t = 1 : TaskNum
        EEFc{t} = Cond(Ec{t}'*Ec{t})\(Fc{t}');
        FFEc{t} = Cond(Fc{t}'*Fc{t})\(Ec{t}');
    end
end
% ����P,S�Խ���
P = sparse(0, 0);
S = sparse(0, 0);
for t = 1 : TaskNum
    P = blkdiag(P, Fc{t}*EEFc{t});
    S = blkdiag(S, Ec{t}*FFEc{t});
end

%% Fit
% MTL_TWSVR1_Xie
H1 = Q + TaskNum/mu1*P;
Alpha = quadprog(symmetric(H1),[],-e2',-v1,[],[],zeros(m2, 1),e2/m2,[],solver);
CAlpha = mat2cell(Alpha, N(2,:));
% MTL_TWSVR2_Xie
H2 = R + TaskNum/mu2*S;
Gamma = quadprog(symmetric(H2),[],-e1',-v2,[],[],zeros(m1, 1),e1/m1,[],solver);
CGamma = mat2cell(Gamma, N(1,:));

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
parfor t = 1 : TaskNum
    U{t} = u - TaskNum/mu1*EEFc{t}*CAlpha{t};
    V{t} = v + TaskNum/mu2*FFEc{t}*CGamma{t};
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

