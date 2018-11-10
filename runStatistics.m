clear;
clc;

Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0);
load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');
load('LabCParams.mat');

%% ͳ��ʵ������
[ MyStat, MyTime, MyRank ] = MyStatistics(Caltech5, CParams, Src, Dst, opts);
save('MyStat-Caltech5.mat', 'MyStat', 'MyTime', 'MyRank');

[ MyStat, MyTime, MyRank ] = MyStatistics(MTL_UCI5, CParams, Src, Dst, opts);
save('MyStat-MTL_UCI5.mat', 'MyStat', 'MyTime', 'MyRank');

[ MyStat, MyTime, MyRank ] = MyStatistics(MLC5, CParams, Src, Dst, opts);
save('MyStat-MLC5.mat', 'MyStat', 'MyTime', 'MyRank');