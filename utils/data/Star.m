function [ X, Y ] = Star( n, m, r )
%STAR �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
% ������
%    n    -ÿ���ص���������
%    m    -����
%    r    -�ذ뾶

    % ����m����������
    X = rand(m, 2);
    Y = (1 : m).';
    % �Ŵ�2r * 2r
    X = X * [2*r 0;0 2*r];
    X = repmat(X, n, 1) + normrnd(0, 0.24, m*n, 2); %wgn(m * n, 2, 5);
    Y = repmat(Y, n, 1);
end