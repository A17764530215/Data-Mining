function [ OStat ] = CVStatistics(IStat)
%CVSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ������֤������ͳ��
%   �˴���ʾ��ϸ˵��

    MStat = mean(IStat);
    OStat = permute(MStat, [2 3 1]);
end

