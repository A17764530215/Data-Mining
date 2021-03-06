function [  ] = SaveFigures( Path, DataSet, LabStat, LabTime, opts )
%SAVEFIGURES 此处显示有关此函数的摘要
% 保存图表
%   此处显示详细说明

    % 交叉验证文件夹
    Dir = [Path, int2str(DataSet.Kfold), '-fold/'];
    if exist(Dir, 'dir') == 0
        mkdir(Dir);
    end
    % 创建文件夹
    Root = [Dir, 'eps/'];
    if exist(Root, 'dir') == 0
        mkdir(Root);
    end
    Root = [Dir, 'fig/'];
    if exist(Root, 'dir') == 0
        mkdir(Root);
    end
    
    % 保存时间图表
    bar(LabTime(:, 1));
    FileName = [DataSet.Name, '-Time'];
    SaveFigure(Dir, FileName);
    
    % 保存误差图表
%     if opts.IndexCount == 4
%         Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
%     elseif opts.IndexCount == 1
%         Indices = {'Accuracy'};
%     else
%         throw(MException('SaveFigures', 'Error in opts.Statistics'));
%     end
    Indices = opts.Indices;
    for i = 1 : length(Indices)
        Index = replace(Indices{i}, '/', '_');
        FileName = [DataSet.Name, '-' Index];
        bar(LabStat(:,:,i), 'DisplayName', FileName);
        SaveFigure(Dir, FileName);
    end
    
    function SaveFigure(Path, FileName)
        StatPath = [Path, 'fig/', FileName];
        saveas(gcf, StatPath, 'fig');
        fprintf('save: %s\n', StatPath);
        StatPath = [Path, 'eps/', FileName];
        saveas(gcf, StatPath, 'epsc');
        fprintf('save: %s\n', StatPath);
    end
end
