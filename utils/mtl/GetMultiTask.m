function [ X, Y, ValInd, TaskNum, Kfold ] = GetMultiTask( DataSet )
%GETMULTITASK �˴���ʾ�йش˺�����ժҪ
% �õ������񽻲���֤���ݼ�
%   �˴���ʾ��ϸ˵��

    X = DataSet.X;
    Y = DataSet.Y;
    ValInd = DataSet.ValInd;
    TaskNum = DataSet.TaskNum;
    Kfold = DataSet.Kfold;
end