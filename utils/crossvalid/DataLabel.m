function [ Dr ] = DataLabel( D, j )
%DATALABEL �˴���ʾ�йش˺�����ժҪ
% ����ǩ�����һ��
%   �˴���ʾ��ϸ˵��
% ������
%    D   -���ݼ�
%    j   -��ǩ������

    [ X, Y ] = SplitDataLabel( D, j );
    Dr = [X, Y];
end