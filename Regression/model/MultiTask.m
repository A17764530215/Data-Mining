function [ TX, TY ] = MultiTask( DataSet, TaskNum )
%MULTITASK �˴���ʾ�йش˺�����ժҪ
% ת�����������ݼ�������һ������
%   �˴���ʾ��ϸ˵��

    TX = cell(TaskNum, 1);
    TY = cell(TaskNum, 1);
    [X, Y] = SplitDataLabel(DataSet.Data, DataSet.Output);
    % ʹ�ý�����֤��������������ݼ�
    idx = crossvalind('Kfold', DataSet.Instances, TaskNum);
    for t = 1 : TaskNum
        TX{t} = X(idx==t,:);
        TY{t} = Y(idx==t,:);
    end
end