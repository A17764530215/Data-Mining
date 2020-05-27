function [ Y ] = SMWInverse( D, U, Cinv, V )
%SMWINVERSE �˴���ʾ�йش˺�����ժҪ
% Sherman�CMorrison�CWoodbury formula
%   �˴���ʾ��ϸ˵��
    
    n = length(D);
    Dinv = [];
    for i = 1 : n
        Dinv = blkdiag(Dinv, inv(D{i}));
    end
    Dinv = sparse(Dinv);

    DinvU = Dinv*U;
    Y = Dinv-DinvU*(Cinv+V*Dinv*U)\DinvU';

end

