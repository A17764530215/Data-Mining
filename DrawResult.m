function [ ] = DrawResult(Stat, Time, label, labels, xTickLabel, arc)
%DRAWRESULT �˴���ʾ�йش˺�����ժҪ
% ����ʵ����
%   �˴���ʾ��ϸ˵��
    if nargin < 6
        arc = 0;
    end
    subplot(1, 2, 1);
    bar(Stat);
    xlabel(label);
    ylabel('Accuracy (%)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
    subplot(1, 2, 2);
    bar(Time);
    xlabel(label);
    ylabel('Training time (ms)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
end

