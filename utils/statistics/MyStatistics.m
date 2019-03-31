function [ MyStat, MyTime, MyRank, MyName ] = MyStatistics(DataSets, IParams, Type, opts)
%MYSTATISTICS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    % �����ļ���
    Src = ['./data/', Type ];
    Dst = ['./lab/', Type ];
    if exist(Src, 'dir') == 0
        mkdir(Src);
    end
    if exist(Dst, 'dir') == 0
        mkdir(Dst);
    end
    
    % ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
    MyStat = [];
    MyTime = [];
    MyRank = [];
    MyName = {};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Src, DataSet, IParams, opts);
            if HasStat == 1
               SaveStatistics(Dst, DataSet, LabStat, LabTime, opts);
               if opts.Mean == 1
                   MyStat = cat(2, MyStat, LabStat(:,1,:));
                   MyTime = cat(2, MyTime, LabTime(:,1));
                   [ ~, IDX ] = sort(LabStat(:,1,1));
                   MyRank = cat(2, MyRank, IDX);
                   MyName = cat(1, MyName, DataSet.Name);
               end
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end