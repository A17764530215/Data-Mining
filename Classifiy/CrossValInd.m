function [ INDICES ] = CrossValInd( Y, Classes, Labels, k )
%CROSSVALIND �˴���ʾ�йش˺�����ժҪ
% ��������ݼ�������֤����
%   �˴���ʾ��ϸ˵��
% ������
%        Y    -���ݼ�
%  Classes    -�����
%   Labels    -��ǩ�б�
%        k    -������֤����
% �����
%  INDICES    -������֤����

    INDICES = zeros(size(Y));
    for i = 1 : Classes
        Yi = find(Y==Labels(i));
        indices = crossvalind('Kfold', Yi, k);
        INDICES(Yi) = indices;
    end
end