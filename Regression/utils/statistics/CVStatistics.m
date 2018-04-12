function [ OStat ] = CVStatistics(IStat)
%CVSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ������֤������ͳ��
%   �˴���ʾ��ϸ˵��

    % ƽ��ֵ/��׼��
    StatM = mean(IStat);
    StatS = std(IStat);
    OStat1 = permute(StatM, [2 3 1]);
    OStat2 = permute(StatS, [2 3 1]);
    OStat = [OStat1; OStat2];
end

