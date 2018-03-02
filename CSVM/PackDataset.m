function [ DataSet ] = PackDataset( Name, Data, Label, Classes, Instances, Attributes, Citation  )
%PACKDATASET �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    d = struct('Name', Name);
    d.Data = Data;
    d.Label = Label;
    d.Classes = Classes;
    d.Instances = Instances;
    d.Attributes = Attributes;
    d.Citation = Citation;    
    DataSet = d;
end