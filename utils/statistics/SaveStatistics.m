function [  ] = SaveStatistics( Path, DataSet, LabStat, LabTime, opts )
%SAVESTATISTICS 此处显示有关此函数的摘要
% 保存统计数据
%   此处显示详细说明

    % 交叉验证文件夹
    Dir = sprintf('%s/%d-fold', Path, DataSet.Kfold);
    if exist(Dir, 'dir') == 0
        mkdir(Dir);
    end
    % 统计数据文件夹
    StatDir = [Dir, '/statistics'];
    if exist(StatDir, 'dir') == 0
        mkdir(StatDir);
    end    
    % 保存统计数据
    StatPath = [StatDir, '/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat', 'LabTime');
    fprintf('save: %s\n', StatPath);
    
    % 保存图表
    if opts.hasfig == 1
        SaveFigures(Path, DataSet, LabStat, LabTime, opts );
    end
end