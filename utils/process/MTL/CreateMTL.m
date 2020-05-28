function [ DataSet ] = CreateMTL( Name, X, Y, Labels, Kfold, Order )
%CREATEMTL �˴���ʾ�йش˺�����ժҪ
% �������������ݼ�
%   �˴���ʾ��ϸ˵��

    DataSet.Name = Name;
    DataSet.TaskNum = length(X);
    DataSet.Kfold = Kfold;
    DataSet.X = X;
    DataSet.Y = Y;
    DataSet.ValInd = MTLCV( X, Kfold );
    DataSet.Labels = Labels;
    DataSet.Order = Order;
end