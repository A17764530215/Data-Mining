function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ��������������ͳ��
%   �˴���ʾ��ϸ˵��

    % �ع�����
    OStat = zeros(2*opts.IndexCount, TaskNum, 2);
    [ Y, I ] = opts.Find(IStat);
    OStat(:,:,1) = Y(1,:,:);
    OStat(:,:,2) = I(1,:,:);
    OStat = permute(OStat, [2 1 3]);
    % ʱ������
    [ Y, I ] = min(ITime);
    OTime = [Y; I];
end