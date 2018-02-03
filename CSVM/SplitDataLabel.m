function [ X, Y ] = SplitDataLabel( D, j )
%SPLITDATALABEL �˴���ʾ�йش˺�����ժҪ
% �ָ������ͱ�ǩ
%   �˴���ʾ��ϸ˵��
% ������
%    D    -���ݼ�
%    j    -��ǩ�У�Ĭ�Ͻ����һ����Ϊ��ǩ
%

    [~, n] = size(D);
    if (nargin < 2) 
        X = D(:, 1:n-1);
        Y = D(:, n);
    elseif j < 1 || j > n
        help SplitDataLabel;
    else
        if j == 1
            X = D(:, 2:n);
        elseif j == n
            X = D(:, 1:n-1);
        else
            X = [D(:, 1:j-1), D(:, j+1:n)];
        end
        Y = D(:, j);
    end
end