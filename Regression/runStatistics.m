Root = cd;

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
        [ LabStat, HasStat ] = LabStatistics(Root, DataSet, IParams);
        if HasStat == 1
            SaveStatitics( Root, DataSet, LabStat )
        end
    end
end