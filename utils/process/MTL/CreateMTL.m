function [ DataSet ] = CreateMTL( Name, Data, ByFeature, Label, Kfold )
%CREATEMTL �˴���ʾ�йش˺�����ժҪ
% �������������ݼ�
%   �˴���ʾ��ϸ˵��

    % PREPROCESS
    Table = Preprocess(Data);
    Table = sortrows(Table, ByFeature);
    [ X, Y ] = SplitDataLabel(Table, Label);
    
    % TO BINARY CLASSIFICATION
    I = Y==1;
    Y(I) = 1; Y(~I) = -1;
    Labels = [-1, 1];
    
    % TO MTL
    if ByFeature < Label
        tab = tabulate(X(:, ByFeature));
        X(:,ByFeature)=  [];
    else
        tab = tabulate(X(:, ByFeature-1));
        X(:,ByFeature-1) = [];
    end
    
    T = tab(:,2);
    X = mat2cell(X, T);
    Y = mat2cell(Y, T);
    
    DataSet.Name = Name;
    DataSet.TaskNum = length(X);
    DataSet.Kfold = Kfold;
    DataSet.X = X;
    DataSet.Y = Y;
    DataSet.ValInd = MTLCV(Y, Kfold);
    DataSet.Labels = Labels;
    DataSet.Order = length(Y);
    
end