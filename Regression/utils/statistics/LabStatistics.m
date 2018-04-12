function [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams)
%STATISTIC �˴���ʾ�йش˺�����ժҪ
% ͳ�Ƶ��������ݼ�
%   �˴���ʾ��ϸ˵��

    HasStat = 0;
    nParams = length(IParams);
    LabStat = zeros(nParams, DataSet.TaskNum, 8);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [Path, './data/', DataSet.Name, '-', Method.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            LabStat(k,:,:) = Stat(:,:,1);
            HasStat = 1;
        end
    end
end