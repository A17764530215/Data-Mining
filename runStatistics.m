Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('MTL_CIFAR_OvO.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
MyStatistics(MTL_CIFAR, CParams, Src, Dst, opts);