function [ DataSet ] = MultiTask( DataSet, TaskNum, Kfold )
%MULTITASK �˴���ʾ�йش˺�����ժҪ
% ת�����������ݼ�������һ������
%   �˴���ʾ��ϸ˵��

    [m, n] = size(DataSet.Data);
    DataSet.Instances = m;
    DataSet.Attributes = n-1;
    DataSet.Output = n;
    % �õ����ݼ�������Ϣ
    Task = crossvalind('Kfold', DataSet.Instances, TaskNum);
    ValInd = zeros(DataSet.Instances, 1);
    for t = 1 : TaskNum
        TaskT = Task==t;
        ValInd(TaskT) = crossvalind('Kfold', sum(TaskT), Kfold);
    end
    DataSet.Task = Task;
    DataSet.TaskNum = TaskNum;
    DataSet.Kfold = Kfold;
    DataSet.ValInd = ValInd;
end