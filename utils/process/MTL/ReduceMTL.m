function [ Xr, Yr ] = ReduceMTL( X, Y, Task, Label )
%REDUCEMTL 此处显示有关此函数的摘要
% 约减多任务数据集
%   此处显示详细说明

    TaskNum = length(Task);
    % 选取任务
    TX = X(Task, 1);
    TY = Y(Task, 1);
    Xr = cell(TaskNum, 1);
    Yr = cell(TaskNum, 1);
    % 选取分类
    for t = 1 : TaskNum
        X = TX{t};
        Y = TY{t};
        % 选取正负类点
        IDX = Y==Label(1)|Y==Label(2);
        Xr{t, 1} = X(IDX,:);
        % 调整标签
        YR = Y(IDX,:);
        YR(YR==Label(1)) = -1;
        YR(YR==Label(2)) = 1;
        Yr{t, 1} = YR;
    end
end