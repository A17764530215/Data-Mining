Root = cd;
Path = [ Root '/data/classify/rbf/' ];

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLClf.mat');

% ʵ�����ݼ�
LabDataSets = {LabMTLClf};

% ʵ������
opts = struct('Statistics', @ClfStat, 'IndexCount', 1);

% ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
m = length(LabDataSets);
for i = 1 : m
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        StatPath = [Path, './statistics/LabStat-', DataSet.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            SaveFigures(Path, DataSet, LabStat, LabTime, opts);
        end
    end
end