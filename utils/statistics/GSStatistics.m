function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ��������������ͳ��
%   �˴���ʾ��ϸ˵��

    % �ع��������
    OStat = zeros(opts.IndexCount, TaskNum, 2);
    % ��ƽ��׼ȷ����ߵ�һ��
    MStat = mean(IStat, 3);
    [ ~, I ] = opts.Find(MStat(:,1));
    % ȡ������ƽ��ֵ
    if opts.Mean
        OStat(:,:,1) = mean(IStat(I,:,:), 3);
        OStat(:,:,2) = I;
    else
        OStat(:,:,1) = IStat(I(1),:,:);
        OStat(:,:,2) = I;
    end
    % ʱ������
    OStat = permute(OStat, [2 1 3]);
    OTime = mean(ITime);
end