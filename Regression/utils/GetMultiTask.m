function [ X, Y, ValInd ] = GetMultiTask( DataSet )
%GETMULTITASK �˴���ʾ�йش˺�����ժҪ
% �õ������񽻲���֤���ݼ�
%   �˴���ʾ��ϸ˵��

    TaskNum = DataSet.TaskNum;
    Task = DataSet.Task;
    X = cell(TaskNum, 1);
    Y = cell(TaskNum, 1);
    ValInd = cell(TaskNum, 1);
    [ Xd, Yd ] = SplitDataLabel(DataSet.Data, DataSet.Output);
    for t = 1 : TaskNum
        T = Task==t;
        X{t} = Xd(T,:);
        Y{t} = Yd(T,:);
        ValInd{t} = DataSet.ValInd(T,:);
    end
end

