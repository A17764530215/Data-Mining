Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLClf.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
MyStatistics(LabMTLClf, CParams, Src, Dst, opts);