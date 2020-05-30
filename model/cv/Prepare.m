function [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2, m1, m2 ] = Prepare(X, Y, N, TaskNum, kernel)
%PREPARE �˴���ʾ�йش˺�����ժҪ
% ����TWSVM�ı�Ҫ�ľ���
%   �˴���ʾ��ϸ˵��

    A = X(Y==1,:);
    B = X(Y==-1,:);
    [m1, ~] = size(A);
    [m2, ~] = size(B);
    % �˺���
    e1 = ones(m1, 1);
    e2 = ones(m2, 1);
    % Kernel
    if strcmp(kernel.type, 'linear')
        E = [A e1];
        F = [B e2];
    else
        E = [Kernel(A, X, kernel) e1];
        F = [Kernel(B, X, kernel) e2];
    end
    % �õ�Q,R����
    EEF = Cond(E'*E)\F';
    FFE = Cond(F'*F)\E';
    Q = F*EEF;
    R = E*FFE;
    % �õ�P,S����
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
end