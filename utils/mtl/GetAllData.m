function [ A, Y, T, N ] = GetAllData( xTrain, yTrain, TaskNum )
%GETALLDATA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    A = cell2mat(xTrain);
    Y = cell2mat(yTrain);
    T = [];
    N = zeros(2, TaskNum);
    for t = 1 : TaskNum
        [m, ~] = size(yTrain{t});
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
        N(1, t) = sum(yTrain{t}==1);
        N(2, t) = sum(yTrain{t}==-1);
    end
end
