function [ ] = DrawResult(Stat, subtitle, labelx, xTickLabel, labely, legends, arc)
%DRAWRESULT 此处显示有关此函数的摘要
% 绘制实验结果
%   此处显示详细说明
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

