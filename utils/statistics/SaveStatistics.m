function [  ] = SaveStatistics( Path, DataSet, LabStat, LabTime, opts )
%SAVESTATISTICS �˴���ʾ�йش˺�����ժҪ
% ����ͳ������
%   �˴���ʾ��ϸ˵��

    % ����ͳ������
    StatPath = [Path, '/statistics/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat', 'LabTime');
    fprintf('save: %s\n', StatPath);
    
    % ����ͼ��
    SaveFigures(Path, DataSet, LabStat, LabTime, opts );
end