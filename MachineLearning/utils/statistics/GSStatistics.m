function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime)
%GSSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ��������������ͳ��
%   �˴���ʾ��ϸ˵��

    % �ع�����
    OStat = zeros(8, TaskNum, 2);
    [ MIN, IDX ] = min(IStat);
    OStat(:,:,1) = MIN(1,:,:);
    OStat(:,:,2) = IDX(1,:,:);
    OStat = permute(OStat, [2 1 3]);
    % ʱ������
    [ MIN, IDX ] = min(ITime);
    OTime = [MIN; IDX];
end
