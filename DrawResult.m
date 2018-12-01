function [ ] = DrawResult(Stat, Time, labels, xTickLabel, arc)
%DRAWRESULT �˴���ʾ�йش˺�����ժҪ
% ����ʵ����
%   �˴���ʾ��ϸ˵��
    if nargin < 5
        arc = 0;
    end
    subplot(2, 1, 1);
    bar(Stat);
    xlabel('#Task');
    ylabel('Accuracy (%)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
    subplot(2, 1, 2);
    bar(Time);
    xlabel('#Task');
    ylabel('Training time (ms)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
end

