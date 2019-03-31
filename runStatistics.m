clear;
clc;

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 实验设置
opts = InitOptions('clf', 1, [], 0, 2);
% 核函数
Src = './data/classify';
Dst = './lab/classify';
Path = './results/classify';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% 统计实验数据
load('DATA.mat')
load('LabCParams.mat');
[ MyStat, MyTime, MyRank ] = MyStatistics(DataSets, CParams, Src, Dst, opts);
path = [Path, '/MyStat.mat'];
save(path, 'MyStat', 'MyTime', 'MyRank');
fprintf(['save: ', path, '\n']);