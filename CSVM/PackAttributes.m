function [ AttributeTypes ] = PackAttributes( n, Real, Integer, Categorical )
%PACKATTRIBUTES �˴���ʾ�йش˺�����ժҪ
% �����������
%   �˴���ʾ��ϸ˵��
% ������
%     n             -���Ը���
%     Real          -��������
%     Integer       -��������
%     Categorical   -��������

    AttributeTypes = zeros(1, n);
    AttributeTypes(1, Real ) = 1;
    AttributeTypes(1, Integer) = 2;
    AttributeTypes(1, Categorical) = 3;
end