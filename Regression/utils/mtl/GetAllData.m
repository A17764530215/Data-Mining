function [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum )
%GETALLDATA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    A = cell2mat(xTrain);
    Y = cell2mat(yTrain);
    T = [];
    for t = 1 : TaskNum
        [m, ~] = size(yTrain{t});
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
end
