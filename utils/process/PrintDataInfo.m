function [  ] = PrintDataInfo( DataSets )
%PRINTDATAINFO �˴���ʾ�йش˺�����ժҪ
% ��ӡ���ݼ���Ϣ
%   �˴���ʾ��ϸ˵��

    nDataSet = length(DataSets);
    fprintf('Name & Instances & Attributes & Classes \\\n');
    for i = 1 : nDataSet
        D = DataSets(i);
        fprintf('%s & %d & %d & %d \\\n', D.Name, D.Instances, D.Attributes, D.Classes);
    end
end