function [ OStat ]  = MTLStatistics(TaskNum, y, yTest)
%MTLSTATISTICS �˴���ʾ�йش˺�����ժҪ
% ������ͳ������
%   �˴���ʾ��ϸ˵��

    OStat = zeros(4, TaskNum);
    for t = 1 : TaskNum
        [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y{t}, yTest{t});
        OStat(:, t) = [ MAE, RMSE, SSE/SST, SSR/SSE ];
    end
end
