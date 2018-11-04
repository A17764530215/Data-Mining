function [ yTest, Time ] = SVM(xTrain, yTrain, xTest, opts)
%CSVM �˴���ʾ�йش����ժҪ
% C-Support Vector Machine
%   �˴���ʾ��ϸ˵��

%% Parse opts
C = opts.C;            % ����
kernel = opts.kernel;  % �˺���

%% Fit
tic
X = xTrain;
Y = yTrain;
% ���ι滮���
e = ones(size(Y));
K = Kernel(X, X, kernel);
I = speye(size(K));
DY = I.*Y;
H = Cond(DY*K*DY);
Alpha = quadprog(H, -e, Y', 0, [], [], 0*e, C*e, [], []);
svi = Alpha > 0;
b = mean(Y(svi,:)-K(svi,:)*(Y(svi,:).*Alpha(svi,:)));
% ֹͣ��ʱ
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:))+b);
yTest(yTest==0) = 1;

end