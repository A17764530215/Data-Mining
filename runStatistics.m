Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('MTL_UCI.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
[ MyStat, MyRank ] = MyStatistics(MTL_UCI([13 14 15 18:26]), CParams, Src, Dst, opts);
save('MyStat-Caltech.mat', 'MyStat', 'MyRank');