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
    % ͳ������
    LabStat = zeros(nParams, TaskNum, opts.IndexCount);
    LabTime = zeros(nParams, 2);
    for k = 1 : nParams
        Method = IParams{k};
        SavePath = sprintf('%s/%s/%d-fold/', Path, Method.kernel.type, DataSet.Kfold);
        Name = [Method.ID, '-', DataSet.Name];
        StatPath = [ SavePath, Name, '.mat'];
        if exist(StatPath, 'file') == 2             
            load(StatPath);
            [ ~, ~, n ] = size(CVStat);
            if n~= DataSet.TaskNum
                ME = MException('LabStatistics', ['TaskNum miss match in ', Method.Name]);
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