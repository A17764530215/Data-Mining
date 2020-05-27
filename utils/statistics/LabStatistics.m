function [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, opts)
%LABSTATISTIC 此处显示有关此函数的摘要
% 统计多任务实验数据
%   此处显示详细说明

    HasStat = 0;
    nParams = length(IParams);
    % 是否多任务平均
    if opts.Mean
        TaskNum = 1;
    else
        TaskNum = DataSet.TaskNum;
    end
    % 统计数据
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
                % 网格搜索结果
                [ Stat, Time ] = GSStatistics(TaskNum, CVStat, CVTime, opts);
                % 保存数据
                LabStat(k,:,:) = Stat(:,:,1);
                LabTime(k,:) = Time(1,:);
                HasStat = 1;
            end        
        end
    end
end