function [  ] = SaveStatistics( Path, DataSet, LabStat )
%SAVESTATISTICS �˴���ʾ�йش˺�����ժҪ
% ����ͳ������
%   �˴���ʾ��ϸ˵��

    % ����ͳ������
    StatPath = [Path, '/statistics/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat');
    fprintf('save: %s\n', StatPath);
    
    % ����ͼ��
    SaveFigures( Path, DataSet, LabStat )
end