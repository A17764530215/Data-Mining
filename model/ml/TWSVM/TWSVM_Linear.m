function [ yTest, Time ] = TWSVM_Linear(xTrain, yTrain, xTest, opts)
%TWSVM �˴���ʾ�йش����ժҪ
% Twin Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
C1 = opts.C1;
C2 = opts.C2;

%% Fit
% ��ʱ
tic
% �ָ��������
A = xTrain(yTrain==1, :);
B = xTrain(yTrain==-1, :);
[m1, ~] = size(A);
[m2, ~] = size(B);
[~, n] = size(xTrain);
e1 = ones(m1, 1);
e2 = ones(m2, 1);
% ����J,Q����
J = [A e1];
Q = [B e2];
J2Q = Cond(J'*J)\Q';
Q2J = Cond(Q'*Q)\J';
% DTWSVM1
lb1 = zeros(m2,1);
ub1 = C1*ones(m2,1);
H1 = Q*J2Q;
Alpha = quadprog(H1, -e2, [], [], [], [], lb1, ub1);
u = -J2Q*Alpha;
w1 = u(1:n);
b1 = u(end);
% DTWSVM2
lb2 = zeros(m1, 1);
ub2 = C2*ones(m1, 1);
H2 = J*Q2J;
Beta = quadprog(H2, -e1, [], [], [], [], lb2, ub2);
v = -Q2J*Beta; 
w2 = v(1:n, :);
b2 = v(end);
% ֹͣ��ʱ
Time = toc;

%% Predict
D1 = abs(xTest*w1+b1);
D2 = abs(xTest*w2+b2);
yTest = sign(D2-D1);
yTest(yTest==0) = 1;

end