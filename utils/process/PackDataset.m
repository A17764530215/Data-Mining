function [ DataSet ] = PackDataset( Name, Data, LabelColumn, Classes, Instances, Attributes, Citation, AttributeTypes  )
%PACKDATASET �˴���ʾ�йش˺�����ժҪ
% ������ݼ�
%   �˴���ʾ��ϸ˵��

    d = struct('Name', Name);
    d.Data = Data;
    d.Output = LabelColumn;
    d.Classes = Classes;
    d.Instances = Instances;
    d.Attributes = Attributes;
    d.Citation = Citation;
    d.AttributeTypes = AttributeTypes;
    DataSet = d;
end