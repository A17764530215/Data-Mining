function [ TX, TY, TK ] = MultiTask( DataSet, TaskNum, Kfold )
%MULTITASK �˴���ʾ�йش˺�����ժҪ
% ת�����������ݼ�������һ������
%   �˴���ʾ��ϸ˵��

    TX = cell(TaskNum, 1);
    TY = cell(TaskNum, 1);
    TK = cell(TaskNum, 1);
    [X, Y] = SplitDataLabel(DataSet.Data, DataSet.Output);
    % ʹ�ý�����֤��������������ݼ�
    idx = crossvalind('Kfold', DataSet.Instances, TaskNum);
    for t = 1 : TaskNum
        TX{t} = X(idx==t,:);
        TY{t} = Y(idx==t,:);
        N = sum(idx==t);
        TK{t} = crossvalind('Kfold', N, Kfold);
    end
end