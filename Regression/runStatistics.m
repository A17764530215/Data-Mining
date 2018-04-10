Path = './data/';

% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% �������ݼ���������������
load('LabUCIReg.mat');
load('LabMulti.mat');
load('LabIParams.mat');

% ʵ�����ݼ�
LabDataSets = {LabUCIReg, LabMulti};
% ͳ��ÿ�����ݼ��ϵĶ�����ʵ������
index = 0;
for i = 1 : 2
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        index = index + 1;
        DataSet = DataSets(j);
        [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams);
        if HasStat == 1
            StatPath = [Path, 'LabStat-', DataSet.Name, '.mat'];
            fprintf('save: %s\n', StatPath);
            save(StatPath, 'LabStat');
        end
    end
end