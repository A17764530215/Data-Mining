function [  ] = PlotMultiClass( D, name, m, n, i, sz, colors )
%PLOTMULTICLASS �˴���ʾ�йش˺�����ժҪ
% ���ƶ�������ݼ�
%   �˴���ʾ��ϸ˵��
% ������
%     D    -���ݼ�
%  name    -ͼ������
%     m    -��
%     n    -��
%     i    -��iλ
%    sz    -��С

    % �ָ������ͱ�ǩ
    [X, Y] = SplitDataLabel(D);
    % �õ���������
    C = unique(Y);
    C = sort(C);
    Cn = length(C);
    % �ֱ����ÿһ���
    for j = 1 : Cn
        subplot(m, n, i);
        title(['Dataset: ', name]);
        xlabel('x1');
        ylabel('x2');
        % ѡ����j����������ɢ��ͼ
        Xj = X(Y==C(j), :);
        scatter(Xj(:, 1), Xj(:, 2), sz, colors(j, :));
        hold on
    end
end