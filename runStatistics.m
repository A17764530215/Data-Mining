clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0, 3);
% �˺���
kernel = 'linear';
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
path = [Path, '/MyStat-', kernel, '.mat'];
save(path, 'MyStat', 'MyTime', 'MyRank');
fprintf(['save: ', path, '\n']);