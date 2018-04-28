function [ ] = MyStatistics(DataSets, IParams, Src, Dst, opts)
%MYSTATISTICS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    % �����ļ���
    if exist(Src, 'dir') == 0
        mkdir(Src);
    end
    if exist(Dst, 'dir') == 0
        mkdir(Dst);
    end
    
    % ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Src, DataSet, IParams, opts);
            if HasStat == 1
               SaveStatistics(Dst, DataSet, LabStat, LabTime, opts);
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end