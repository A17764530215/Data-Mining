function [ Y ] = Kernel(U, V, opts)
%KERNEL �˴���ʾ�йش����ժҪ
% �˺���
%   �˴���ʾ��ϸ˵��

    switch (opts.type)
        case 'linear'
            Y = U*V.';
        case 'poly'
            Y = (1 + (U*V.')).^opts.p1;
        case 'rbf'
            [ m, ~ ] = size(V);
            [ n, ~ ] = size(U);
            Y = exp(-(repmat(sum(U.*U,2)',m,1)+repmat(sum(V.*V,2),1,n) - 2*V*U')/(2*opts.p1^2));
            Y = Y';
    end
end