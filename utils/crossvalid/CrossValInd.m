function [ INDICES ] = CrossValInd( N, K )
%CROSSVALIND �˴���ʾ�йش˺�����ժҪ
% �ع����ݼ�������֤����
%   �˴���ʾ��ϸ˵��
% ������
%        N    -������
%        K    -������֤����
% �����
%  INDICES    -������֤����

    INDICES = crossvalind('Kfold', N, K);
end