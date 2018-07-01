Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('MTL_Caltech101.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 0, []);
MyStat = MyStatistics(MTL_Caltech101, CParams, Src, Dst, opts);
save('MyStat-MTL_Caltech101.mat', 'MyStat');