function [ X, Y ] = SplitDataLabel( D )
%SPLITDATALABEL �˴���ʾ�йش˺�����ժҪ
% �ָ������ͱ�ǩ
%   �˴���ʾ��ϸ˵��
    [~, n] = size(D);
    X = D(:, 1:n-1);
    Y = D(:, n);
end