%% ��������ݼ�
load('LabMCL.mat');
Datasets = [];
for i = 1 : 14
    D = LabMCL(i);
    nclass = length(D.Labels);
    opts = struct('nclass', nclass, 'labels', D.Labels, 'count', 0, 'mode', 'RvO');
    [ Xr, Yr ] = MC2MT(D.X, D.Y, opts);
    Dataset = MyReduce(Xr, Yr, D.Name, 1:nclass-1, [0,1], 0, true, 3);
    Datasets = cat(1, Datasets, Dataset);
end

%% �ϲ��������ݼ�
% ����
load('MLC5.mat');
load('Caltech5.mat');
load('MTL5.mat');
load('MTL_UCI5.mat');
DataSets = {MTL_UCI5;Caltech5;MLC5;MTL5};
DataSets = cellcat(DataSets, 1);
save DATA5.mat DataSets;
% ����
load('MTL_UCI.mat');
load('Caltech.mat');
DataSets = {MTL_UCI;Caltech};
DataSets = cellcat(DataSets, 1);
save DATA3.mat DataSets;

%% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));