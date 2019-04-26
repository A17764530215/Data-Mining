function [ Dst ] = MTLData( dimension, sample_size, task,  kfold )
%MTLDATA 此处显示有关此函数的摘要
%   此处显示详细说明

    X = cell(task ,1);
    Y = cell(task ,1);
    ValInd = cell(task ,1);
    for i = 1: task
        X{i} = rand(sample_size, dimension);
        Y{i} = rand(sample_size, 1);
        ValInd{i} = crossvalind('Kfold', sample_size, kfold);
    end
    
    Dst.Name = 'TestMTL';
    Dst.TaskNum = task;
    Dst.Kfold = kfold;
    Dst.X = X;
    Dst.Y = Y;
    Dst.ValInd = ValInd;

end

