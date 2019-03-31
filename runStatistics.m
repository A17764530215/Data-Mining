clear;
clc;

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 实验设置
opts = InitOptions('clf', 1, [], 0, 2);

% 加载数据和参数
load('DATA5.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

RParams = mat2cell(RParams, [14, 14, 14]);
CParams = mat2cell(CParams, [15, 15, 15]);
SParams = mat2cell(SParams, [4, 4]);

%% 统计数据
[ MyStat, MyTime, MyRank, MyName ] = MyStatistics(DataSets, CParams{3}, 'classify', opts);
save('./results/MyStat-RBF-Classify.mat', 'MyStat', 'MyTime', 'MyRank', 'MyName');