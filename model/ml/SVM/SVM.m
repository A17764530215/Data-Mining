function [ yTest, Time ] = SVM(xTrain, yTrain, xTest, opts)
%CSVM �˴���ʾ�йش����ժҪ
% C-Support Vector Machine
%   �˴���ʾ��ϸ˵��
    
%% Parse opts
    C = opts.C;            % ����
    kernel = opts.kernel;  % �˺���

%% Fit
    tic
    [m, ~] = size(xTrain);
    % ���ι滮���
    f = -ones(m, 1);
    lb = zeros(m, 1);
    ub = C*ones(m, 1);
    H = diag(yTrain)*Kernel(xTrain, xTrain, kernel)*diag(yTrain);
    H = Utils.Cond(H);
    [ Alpha ] = quadprog(H, f, [], [], [], [], lb, ub, [], []);
    % ֹͣ��ʱ
    Time = toc;

%% Predict
    yTest = sign(Kernel(xTest, xTrain, kernel)*diag(yTrain)*Alpha);
    yTest(yTest==0) = 1;
    
end