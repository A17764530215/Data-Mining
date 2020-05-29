function [ Indices ] = MTLCV( Y, k )
%MTLCV 此处显示有关此函数的摘要
% 多任务交叉验证设置
%   此处显示详细说明

    TaskNum = size(Y, 1);
    Indices = cell(TaskNum, 1);
    for i =  1 : TaskNum
        Indices{i} = crossvalind('Kfold', length(Y{i}), k);
    end
end

