function [  ] = SaveFigures( Path, DataSet, LabStat, LabTime )
%SAVEFIGURES �˴���ʾ�йش˺�����ժҪ
% ����ͼ��
%   �˴���ʾ��ϸ˵��

    % ����ʱ��ͼ��
    bar(LabTime(:, 1));
    FileName = [DataSet.Name, '-Time'];
    SaveFigure(Path, FileName);
    
    % �������ͼ��
    Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
    for i = 1 : 4
        Index = replace(Indices{i}, '/', '_');
        FileName = [DataSet.Name, '-' Index];
        bar(LabStat(:,:,i), 'DisplayName', FileName);
        SaveFigure(Path, FileName);
    end
    
    function SaveFigure(Path, FileName)
        StatPath = [Path, '/fig/', FileName];
        saveas(gcf, StatPath, 'fig');
        fprintf('save: %s\n', StatPath);
        StatPath = [Path, '/eps/', FileName];
        saveas(gcf, StatPath, 'epsc');
        fprintf('save: %s\n', StatPath);
    end
end
