function [  ] = PlotTree( X, Tree, Rho )
%PLOTTREE �˴���ʾ�йش˺�����ժҪ
% ������
%   �˴���ʾ��ϸ˵��
% ������
%      X    -���ݼ�
%   Tree    -��

    [m ,~] = size(X);
    [rho, ~] = mapminmax(Rho.', 0, 1);
    for i = 1 : m
        % ��ʼ����
        u = i;
        v = Tree(i);
        % ��ʼ������
        a = [X(u, 1) X(v, 1)];
        b = [X(u, 2) X(v, 2)];
        % ��������
%         plot(a, b, '-k');
        plot(a, b, 'Color', [rho(v), rho(v), 0]);
        hold on;
    end
end