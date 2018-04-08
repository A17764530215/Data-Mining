function [ Xn, Yn ] = Normalize( X, Y )
%NORMALIZE �˴���ʾ�йش˺�����ժҪ
% ��׼��������
%   �˴���ʾ��ϸ˵��

    [m, ~] = size(X);
    Xn = cell(m, 1);
    Yn = cell(m, 1);
    for t = 1 : m
        Xn{t} = zscore(X{t});
        Yn{t} = Y{t};
    end
end

