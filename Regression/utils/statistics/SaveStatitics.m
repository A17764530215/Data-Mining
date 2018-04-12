function [  ] = SaveStatitics( Path, DataSet, LabStat )
%SAVESTATITICS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    % ����ͳ������
    StatPath = [Path, '/statistics/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat');
    fprintf('save: %s\n', StatPath);
    % ����ͼ��
    Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
    for i = 1 : 4
        Index = replace(Indices{i}, '/', '_');
        FileName = [DataSet.Name, '-' Index];
        % bar
        bar(LabStat(:,:,i), 'DisplayName', FileName);
        % save as .fig
        StatPath = [Path, '/fig/', FileName];
        saveas(gcf, StatPath, 'fig');
        fprintf('save: %s\n', StatPath);
        % save as .eps
        StatPath = [Path, '/eps/', FileName];
        saveas(gcf, StatPath, 'epsc');
        fprintf('save: %s\n', StatPath);
    end
end