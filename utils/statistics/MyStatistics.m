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
    RowNames = {}; Time = []; Rank = []; Data = [];
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Src, DataSet, IParams, opts);
            if HasStat == 1
               SaveStatistics(Dst, DataSet, LabStat, LabTime, opts);
               if opts.Mean == 1
                   RowNames = cat(2, RowNames, DataSet.Name);
                   Data = cat(2, Data, LabStat(:,1,:));
                   Time = cat(2, Time, LabTime(:,1));
                   [ ~, IDX ] = sort(LabStat(:,1,1));
                   Rank = cat(2, Rank, IDX);
               end
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
    % convert to table
    m = length(IParams);
    VariableNames = cell(1, m);
    for i = 1 : m
        VariableNames{i} = IParams{i}.ID;
    end
    % convert to table
    Rank = cell2table(num2cell(Rank'), 'VariableNames', VariableNames, 'RowNames', RowNames);
    Time = cell2table(num2cell(Time'*1000), 'VariableNames', VariableNames, 'RowNames', RowNames);
    Stats = struct('Rank', Rank, 'Time',  Time);
    n = length(opts.Indices);
    for i = 1 : n
        Index = cell2table(num2cell(Data(:,:,i)'*100),'VariableNames', VariableNames, 'RowNames', RowNames);
        Stats.(opts.Indices{i}) = Index;
    end
    % remaining
    d.VariableNames = VariableNames;
    d.RowNames = RowNames; 
    d.Methods = IParams;
    d.Stats = Stats;
end