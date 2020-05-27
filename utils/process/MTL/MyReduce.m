function [ Dst ] = MyReduce(X, Y, Name, Tasks, Labels, count, biased, kfold)
%MYREDUCE 此处显示有关此函数的摘要
%   此处显示详细说明
    [X, Y] = ReduceMTL(X, Y, Tasks, Labels);
    if count > 0
        [X, Y] = ReduceData(X, Y, count, biased);
    end
    Dst = CreateMTL(Name, X, Y, Labels, kfold);
end

