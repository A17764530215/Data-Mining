function [  ] = SaveStatistics( Path, DataSet, LabStat, LabTime, opts )
%SAVESTATISTICS �˴���ʾ�йش˺�����ժҪ
% ����ͳ������
%   �˴���ʾ��ϸ˵��

    % ������֤�ļ���
    Dir = sprintf('%s/%d-fold', Path, DataSet.Kfold);
    if exist(Dir, 'dir') == 0
        mkdir(Dir);
    end
    % ͳ�������ļ���
    StatDir = [Dir, '/statistics'];
    if exist(StatDir, 'dir') == 0
        mkdir(StatDir);
    end    
    % ����ͳ������
    StatPath = [StatDir, '/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat', 'LabTime');
    fprintf('save: %s\n', StatPath);
    
    % ����ͼ��
    if opts.hasfig == 1
        SaveFigures(Path, DataSet, LabStat, LabTime, opts );
    end
end