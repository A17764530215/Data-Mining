function [  ] = PlotCurve( X, Y, name, m, n, i, sz, color )
%PLOTCURVE �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
% ������
%     D    -���ݼ�
%  name    -ͼ������
%     m    -��
%     n    -��
%     i    -��iλ
%    sz    -��С
% color    -��ɫ

    % ��x��������
    [x, idx] = sort(X(:,1));
    y = Y(idx,1);
    % ��ͼ
    subplot(m, n, i);
    title(name);
    xlabel('x');
    ylabel('y');
    plot(x, y, sz, color);
    hold on
end