function [ Indices ] = MTLCV( Y, k )
%MTLCV �˴���ʾ�йش˺�����ժҪ
% �����񽻲���֤����
%   �˴���ʾ��ϸ˵��

    TaskNum = size(Y, 1);
    Indices = cell(TaskNum, 1);
    for i =  1 : TaskNum
        Indices{i} = crossvalind('Kfold', length(Y{i}), k);
    end
end

