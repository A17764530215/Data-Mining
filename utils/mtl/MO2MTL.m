function [ DataSet ] = MO2MTL( Name, X, Y, Kfold )
%MO2MTL �˴���ʾ�йش˺�����ժҪ
% ��������ݼ�ת���������ݼ�
%   �˴���ʾ��ϸ˵��

    [~, l] = size(X);
    [m, n] = size(Y);
    XX = repmat(X, n, 1);
    YY = reshape(Y, m*n, 1);
    Data = [XX YY];
    valind = crossvalind('Kfold', m, 5);
    ValInd = repmat(valind, n, 1);
    Task = [];
    for i = 1 : n
        Task = cat(1, Task, i*ones(m, 1));
    end
    DataSet.Name = Name;
    DataSet.Data = Data;
    DataSet.Instances = n*m;
    DataSet.Attributes = l - 1;
    DataSet.Output = l;
    DataSet.TaskNum = n;
    DataSet.Task = Task;
    DataSet.Kfold = Kfold;
    DataSet.ValInd = ValInd;
end

