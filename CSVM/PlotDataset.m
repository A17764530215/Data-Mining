function [  ] = PlotDataset( D, name, m, n, i, sz, cp, cn )
%PLOTDATASET �˴���ʾ�йش˺�����ժҪ
% �������ݼ�
%   �˴���ʾ��ϸ˵��
% ������
%     D    -���ݼ�
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