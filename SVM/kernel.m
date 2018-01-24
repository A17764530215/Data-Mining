function [ H ] = kernel( ker, U, V )
%KERNEL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    [ru, ~] = size(U);
    [rv, ~] = size(V);
    H = zeros(ru, rv);
    for i = 1 : ru
        for j = 1 : rv
            H(i, j) = svkernel(ker, U(i,:), V(j,:));
        end
    end
end