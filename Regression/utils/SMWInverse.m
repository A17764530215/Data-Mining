function [ X ] = SMWInverse( A, P, rho )
%SMWINVERSE �˴���ʾ�йش˺�����ժҪ
% Sherman�CMorrison�CWoodbury formula
% $(A^TA+\frac{1}{\rho}*P)^{-1}$
%   �˴���ʾ��ϸ˵��
    
    n = length(P);
    Pinv = [];
    for i = 1 : n
        Pinv = blkdiag(Pinv, inv(P{i}));
    end
    I = eye(size(Pinv));
    H = I+rho*A*Pinv*A';
    X = rho*Pinv-rho^2*Pinv*A'*H\A*Pinv;
end

