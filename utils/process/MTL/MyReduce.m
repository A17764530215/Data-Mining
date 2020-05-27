function [ Dst ] = MyReduce(X, Y, Name, Tasks, Labels, count, biased, kfold)
%MYREDUCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [X, Y] = ReduceMTL(X, Y, Tasks, Labels);
    if count > 0
        [X, Y] = ReduceData(X, Y, count, biased);
    end
    Dst = CreateMTL(Name, X, Y, Labels, kfold);
end

