function [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams)
%STATISTIC �˴���ʾ�йش˺�����ժҪ
% ͳ�Ƶ��������ݼ�
%   �˴���ʾ��ϸ˵��

    HasStat = 0;
    nParams = length(IParams);
    LabStat = zeros(nParams, DataSet.TaskNum, 8);
    LabTime = zeros(nParams, 2);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [Path, './data/', DataSet.Name, '-', Method.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            [ ~, ~, n ] = size(CVStat);
            if n~= DataSet.TaskNum
                ME = MException('LabStatistics', 'TaskNum miss match in %s\n', Method.Name);
                throw(ME);
            else
                % �����������
                [ Stat, Time ] = GSStatistics(DataSet.TaskNum, CVStat, CVTime);
                % ��������
                LabStat(k,:,:) = Stat(:,:,1);
                LabTime(k,:) = Time(1,:);
                HasStat = 1;
            end
        end
    end
end