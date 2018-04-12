function [ OStat ] = GSStatistics(TaskNum, IStat)
%GSSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ��������������ͳ��
%   �˴���ʾ��ϸ˵��

    OStat = zeros(4, TaskNum, 2);
    [ MIN, IDX ] = min(IStat);
    OStat(:,:,1) = MIN(1,:,:);
    OStat(:,:,2) = IDX(1,:,:);
    OStat = permute(OStat, [2 1 3]);
end
