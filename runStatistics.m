Root = cd;
Path = [ Root '/data/regression/'];

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLReg.mat');
load('LabRParams.mat');
IParams = RParams;

% ʵ�����ݼ�
LabDataSets = {LabMTLReg};

% ʵ������
opts = InitOptions('reg', []);

% ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
m = length(LabDataSets);
for i = 1 : m
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, 1, opts);
            if HasStat == 1
               SaveStatistics(Root, DataSet, LabStat, LabTime, opts);
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end