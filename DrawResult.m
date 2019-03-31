function [ ] = DrawResult(Stat, subtitle, labelx, xTickLabel, labely, legends, arc)
%DRAWRESULT �˴���ʾ�йش˺�����ժҪ
% ����ʵ����
%   �˴���ʾ��ϸ˵��
    if nargin < 7
        arc = 0;
    end
    bar(Stat);
    title(subtitle)
    xlabel(labelx);
    ylabel(labely);
    legend(legends, 'Location', 'northwest');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
end

