function [  ] = PlotDataset( D, m, n, i, name, sz, cp, cn )
%PLOTDATASET �˴���ʾ�йش˺�����ժҪ
% �������ݼ�
%   �˴���ʾ��ϸ˵��
% ������
%     m    -��
%     n    -��
%     i    -��iλ
%    sz    -��С
%    cp    -�������ʽ
%    cn    -�������ʽ
%
    subplot(m, n, i);
    title(['Method: ', name]);
    xlabel('x1');
    ylabel('x2');
    Scatter(D, sz, cp, cn);
end