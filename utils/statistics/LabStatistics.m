function [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, opts)
%LABSTATISTIC �˴���ʾ�йش˺�����ժҪ
% ͳ�ƶ�����ʵ������
%   �˴���ʾ��ϸ˵��

    HasStat = 0;
    nParams = length(IParams);
    % �Ƿ������ƽ��
    if opts.Mean
        TaskNum = 1;
    else
        TaskNum = DataSet.TaskNum;
    end
    % ʵ���ļ���
    StatDir = [ Path, int2str(DataSet.Kfold) '-fold/' ];
    if exist(StatDir, 'dir') == 0
        LabStat = [];
        LabTime = [];
        HasStat = 0;
        return;
    end
    % ͳ������
    LabStat = zeros(nParams, TaskNum, 2*opts.IndexCount);
    LabTime = zeros(nParams, 2);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [ StatDir, Method.Name, '-', DataSet.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            [ ~, ~, n ] = size(CVStat);
            if n~= DataSet.TaskNum
                ME = MException('LabStatistics', 'TaskNum miss match in %s\n', Method.Name);
                throw(ME);
            else
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