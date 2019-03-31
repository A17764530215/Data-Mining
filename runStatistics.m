clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0, 2);
% �˺���
Src = './data/classify';
Dst = './lab/classify';
Path = './results/classify';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% ͳ��ʵ������
load('DATA.mat')
load('LabCParams.mat');
[ MyStat, MyTime, MyRank ] = MyStatistics(DataSets, CParams, Src, Dst, opts);
path = [Path, '/MyStat.mat'];
save(path, 'MyStat', 'MyTime', 'MyRank');
fprintf(['save: ', path, '\n']);