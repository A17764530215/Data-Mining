function [  ] = Scatter( D, sz, cp, cn)
%SCATTER �˴���ʾ�йش˺�����ժҪ
% ����ɢ��ͼ
%   �˴���ʾ��ϸ˵��
% ������
%    D   -���ݼ�
%    sz  -��С
%    cp  -�������ʽ
%    cn  -�������ʽ

    % �ָ������ͱ�ǩ
    [X, Y] = SplitDataLabel(D);
    % �ָ��������
    Xp = X(Y==1, :); Xn = X(Y==-1, :);
    % ���������
    scatter(Xp(:, 1), Xp(:, 2), sz, cp);
    hold on
    % ���Ƹ����
    scatter(Xn(:, 1), Xn(:, 2), sz, cn);
    hold on;
end