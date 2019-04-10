function [ d ] = MyStatistics(DataSets, IParams, Type, opts)
%MYSTATISTICS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    % �����ļ���
    Src = ['./data/', lower(Type) ];
    Dst = ['./lab/', lower(Type) ];
    if exist(Src, 'dir') == 0
        mkdir(Src);
    end
    if exist(Dst, 'dir') == 0
        mkdir(Dst);
    end
    
    % ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
    Name = {}; Time = []; Rank = []; Data = []; 
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Src, DataSet, IParams, opts);
            if HasStat == 1
               SaveStatistics(Dst, DataSet, LabStat, LabTime, opts);
               if opts.Mean == 1
                   Data = cat(2, Data, LabStat(:,1,:));
                   Time = cat(2, Time, LabTime(:,1));
                   [ ~, IDX ] = sort(LabStat(:,1,1));
                   Rank = cat(2, Rank, IDX);
                   Name = cat(1, Name, DataSet.Name);
               end
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
    d.Name = Name; d.Time = Time;
    d.Rank = Rank; d.Data = Data;
end