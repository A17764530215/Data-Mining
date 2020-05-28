function [ X, Y ] = BatchSplit( D, T, k )
%BATCHSPLIT �˴���ʾ�йش˺�����ժҪ
% �����ָ�������ǩ
%   �˴���ʾ��ϸ˵��

    X = cell(T, 1);
    Y = cell(T, 1);
    for i = 1 : T
        [X{i,1}, Y{i,1}] = SplitDataLabel(D{i,1}, k);
        n = sum(D{i, 1}(:,k));
        fprintf('[%d]number of positive samples: %d\n', i, n);
    end
end