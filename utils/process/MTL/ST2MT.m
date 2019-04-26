function [ X, Y, C ] = ST2MT(DataSet, i)
%ST2MT 此处显示有关此函数的摘要
% 单任务转多任务数据集
%   此处显示详细说明

    [ Data, ~ ] = Preprocess(DataSet.Data, DataSet.AttributeTypes);
    [ X , Y ] = SplitDataLabel(Data, DataSet.Output);
    X = sortrows(X, i);
    % 统计第i列的频数分布
    tab = tabulate(X(:, i));
    cnt = tab(:,2)>0;
    idx = tab(cnt,1);
    idn = tab(cnt,2);
    % 去掉作为任务划分的第i列
    X(:,i)=  [];
    % 构造多任务数据集
    X = mat2cell(X, idn);
    Y = mat2cell(Y, idn);
    C = idx;
end