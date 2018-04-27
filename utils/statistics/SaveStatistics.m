function [  ] = SaveStatistics( Path, DataSet, LabStat, LabTime, opts )
%SAVESTATISTICS �˴���ʾ�йش˺�����ժҪ
% ����ͳ������
%   �˴���ʾ��ϸ˵��

    Root = [Path, '/statistics/'];
    if exist(Root, 'dir') == 0
        mkdir(Root);
    end
    
    % ����ͳ������
    StatPath = [Path, '/statistics/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat', 'LabTime');
    fprintf('save: %s\n', StatPath);
    
    % ����ͼ��
    SaveFigures(Path, DataSet, LabStat, LabTime, opts );
end