function [ M ] = XYDist( X, Y )
%XYDIST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [m, ~] = size(X);
    [n, ~] = size(Y);
    M = zeros(m, n);
    for i = 1 : m
        for j = 1 : n
            M(i, j) = norm(X(i, :)-Y(j, :));
        end
    end
end