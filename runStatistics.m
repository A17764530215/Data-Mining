Root = cd;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabReg.mat');
load('LabIParams-Linear.mat');

% ʵ�����ݼ�
LabDataSets = {LabReg};

% ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
m = length(LabDataSets);
for i = 1 : m
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Root, DataSet, IParams, 0);
            if HasStat == 1
               SaveStatistics(Root, DataSet, LabStat, LabTime);
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end