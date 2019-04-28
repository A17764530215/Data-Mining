function [ DataSet ] = CreateMTL( Name, X, Y, Labels, Kfold )
%CREATEMTL 此处显示有关此函数的摘要
% 创建多任务数据集
%   此处显示详细说明

    DataSet.Name = Name;
    DataSet.TaskNum = length(X);
    DataSet.Kfold = Kfold;
    DataSet.X = X;
    DataSet.Y = Y;
    DataSet.ValInd = MTLCV( X, Kfold );
    DataSet.Labels = Labels;
    DataSet.Order = length(X) * size(X{1,1}, 1);
end