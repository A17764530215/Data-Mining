function [ INDICES ] = MTLCV( X, k )
%MTLCV 此处显示有关此函数的摘要
% 多任务交叉验证设置
%   此处显示详细说明

    TaskNum = size(X, 1);
    INDICES = cell(TaskNum, 1);
    for i =  1 : TaskNum
        m = size(X{i}, 1);
        INDICES{i} = CrossValInd(m, k);
    end
end

