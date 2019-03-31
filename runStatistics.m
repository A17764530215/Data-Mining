clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0, 2);

% �������ݺͲ���
load('DATA5.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

RParams = mat2cell(RParams, [14, 14, 14]);
CParams = mat2cell(CParams, [15, 15, 15]);
SParams = mat2cell(SParams, [4, 4]);

%% ͳ������
[ MyStat, MyTime, MyRank, MyName ] = MyStatistics(DataSets, CParams{3}, 'classify', opts);
save('./results/MyStat-RBF-Classify.mat', 'MyStat', 'MyTime', 'MyRank', 'MyName');