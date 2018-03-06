function [ DataSet ] = PackDataset( Name, Data, LabelColumn, Classes, Instances, Attributes, Citation  )
%PACKDATASET �˴���ʾ�йش˺�����ժҪ
% ������ݼ�
%   �˴���ʾ��ϸ˵��

    d = struct('Name', Name);
    d.Data = Data;
    d.LabelColumn = LabelColumn;
    d.Classes = Classes;
    d.Instances = Instances;
    d.Attributes = Attributes;
    d.Citation = Citation;    
    DataSet = d;
end