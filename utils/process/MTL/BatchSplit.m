function [ X, Y ] = BatchSplit( D, T, k )
%BATCHSPLIT 此处显示有关此函数的摘要
% 批量分割样本标签
%   此处显示详细说明

    X = cell(T, 1);
    Y = cell(T, 1);
    for i = 1 : T
        [X{i,1}, Y{i,1}] = SplitDataLabel(D{i,1}, k);
        n = sum(D{i, 1}(:,k));
        fprintf('[%d]number of positive samples: %d\n', i, n);
    end
end