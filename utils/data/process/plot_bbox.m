function [  ] = plot_bbox( box )
%PLOT_BBOX 此处显示有关此函数的摘要
%   此处显示详细说明

    rectangle('position', [box(1), box(2), box(3)-box(1), box(4)-box(2)]);
end