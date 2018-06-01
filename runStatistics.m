Src = './data/classify/linear/';
Dst = './lab/classify/linear/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('MTL_CIFAR.mat');
load('LabCParams-Linear.mat');

% ʵ������
opts = InitOptions('clf', 0, []);
MyStatistics(MTL_CIFAR, CParams, Src, Dst, opts);