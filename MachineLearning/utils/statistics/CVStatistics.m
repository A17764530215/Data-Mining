function [ OStat, TStat ] = CVStatistics(IStat, ITime)
%CVSTATISTICS �˴���ʾ�йش˺�����ժҪ
% �����񽻲���֤ͳ��
%   �˴���ʾ��ϸ˵��

    OStat1 = permute(mean(IStat), [2 3 1]);
    OStat2 = permute(std(IStat), [2 3 1]);
    OStat = [OStat1; OStat2];
    TStat = [mean(ITime) std(ITime)];
end

