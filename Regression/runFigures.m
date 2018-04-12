Path = cd;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabSVMReg.mat');
load('LabUCIReg.mat');
load('LabMulti.mat');
load('LabIParams.mat');

% ʵ�����ݼ�
LabDataSets = {LabSVMReg, LabUCIReg, LabMulti};

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
            SaveFigures(Path, DataSet, LabStat);
        end
    end
end