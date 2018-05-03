Src = './data/regression/linear/';
Dst = './lab/regression/linear/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLReg.mat');
load('LabRParams-Linear.mat');

% ʵ������
opts = InitOptions('reg', 1, []);
MyStatistics(LabMTLReg, RParams, Src, Dst, opts);