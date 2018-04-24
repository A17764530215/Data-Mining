function [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, Mean, opts)
%LABSTATISTIC �˴���ʾ�йش˺�����ժҪ
% ͳ�ƶ�����ʵ������
%   �˴���ʾ��ϸ˵��

    if Mean
        TaskNum = 1;
    else
        TaskNum = DataSet.TaskNum;
    end
    HasStat = 0;
    nParams = length(IParams);
    LabStat = zeros(nParams, TaskNum, 2*opts.IndexCount);
    LabTime = zeros(nParams, 2);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [Path, DataSet.Name, '-', Method.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            [ ~, ~, n ] = size(CVStat);
            if n~= DataSet.TaskNum
                ME = MException('LabStatistics', 'TaskNum miss match in %s\n', Method.Name);
                throw(ME);
            else
                % ȡ������ƽ��ֵ
                if Mean
                    CVStat = mean(CVStat, 3);
                end
                % �����������
                [ Stat, Time ] = GSStatistics(TaskNum, CVStat, CVTime, opts);
                % ��������
                LabStat(k,:,:) = Stat(:,:,1);
                LabTime(k,:) = Time(1,:);
                HasStat = 1;
            end
        end
    end
end