function [ Xn ] = Normalize( X )
%NORMALIZE �˴���ʾ�йش˺�����ժҪ
% ��׼��������
%   �˴���ʾ��ϸ˵��

    [m, ~] = size(X);
    Xn = cell(m, 1);
    for t = 1 : m
        Xn{t} = zscore(X{t});
    end
end

