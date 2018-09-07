function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ��������������ͳ��
%   �˴���ʾ��ϸ˵��

    % �ع��������
    OStat = zeros(2*opts.IndexCount, TaskNum, 2);
    % ȡ������ƽ��ֵ
    if opts.Mean
        Stat = IStat(:,1,:);
        Stat = permute(Stat, [1 3 2]);
        Mean_ = mean(Stat, 2);
        [ ~, I ] = opts.Find(Mean_);
        OStat(:,:,1) = [mean(Stat(I,:));std(Stat(I,:))];
        OStat(:,:,2) = [I;I];
    else
        [ Y, I ] = opts.Find(IStat);
        OStat(:,:,1) = Y(1,:,:);
        OStat(:,:,2) = I(1,:,:);
    end
    % ʱ������
    OStat = permute(OStat, [2 1 3]);
    OTime = mean(ITime);
end