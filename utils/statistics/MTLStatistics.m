function [ OStat ]  = MTLStatistics(TaskNum, y, yTest, opts)
%MTLSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ������ͳ������
%   �˴���ʾ��ϸ˵��

    Statistics = opts.Statistics;
    OStat = zeros(opts.IndexCount, TaskNum);
    for t = 1 : TaskNum
        OStat(:, t) = Statistics(y{t}, yTest{t});
    end
end