function [ ] = DrawResult(Stat, Time, labels, xLabels, arc)
%DRAWRESULT �˴���ʾ�йش˺�����ժҪ
% ����ʵ����
%   �˴���ʾ��ϸ˵��
    if nargin < 5
        arc = 0;
    end
    subplot(1, 2, 1);
    bar(Stat);
    xlabel('#Task');
    ylabel('Accuracy (%)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xLabels, 'XTickLabelRotation', arc);
    subplot(1, 2, 2);
    bar(Time);
    xlabel('#Task');
    ylabel('Training time (ms)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xLabels, 'XTickLabelRotation', arc);
end

