function [ OStat ]  = MTLStatistics(TaskNum, y, yTest, Time)
%MTLSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ������ͳ������
%   �˴���ʾ��ϸ˵��

    OStat = zeros(4, TaskNum);
    for t = 1 : TaskNum
        [ MAE, RMSE, SSET, SSRT ] = Statistics(y{t}, yTest{t});
        OStat(:, t) = [ MAE, RMSE, SSET, SSRT ];
    end
end
