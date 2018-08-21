Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('Caltech.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
[ MyStat, MyRank ] = MyStatistics(Caltech, CParams, Src, Dst, opts);
save('MyStat-Caltech.mat', 'MyStat', 'MyRank');