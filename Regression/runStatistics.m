Path = './data/';

% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

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
        [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams);
        if HasStat == 1
            FileName = ['LabStat-', DataSet.Name];
            StatPath = ['./statistics/', FileName, '.mat'];
            fprintf('save: %s\n', StatPath);
            save(StatPath, 'LabStat');
            bar(LabStat(:,:,1), 'DisplayName', FileName);
            savefig(['./figures/', FileName, '.fig']);
        end
    end
end