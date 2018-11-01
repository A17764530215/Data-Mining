clear;
clc;

Src = './data/classify/poly/';
Dst = './lab/classify/poly/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

%% �������ݼ���������������
load('Caltech5.mat');
load('LabCParams-Linear.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
[ MyStat, MyTime, MyRank ] = MyStatistics(Caltech5([6:15]), CParams, Src, Dst, opts);
save('MyStat-Caltech5.mat', 'MyStat', 'MyTime', 'MyRank');
% MyTime = MyTime([6 7 10 8 11 9],:,:);
% MyStat = MyStat([6 7 10 8 11 9],:,:);

%% �������ݼ���������������
load('MTL_UCI5.mat');
load('LabCParams-Ploy.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
[ MyStat, MyTime, MyRank ] = MyStatistics(MTL_UCI5([28 ]), CParams, Src, Dst, opts);
save('MyStat-MTL_UCI5.mat', 'MyStat', 'MyTime', 'MyRank');

%% �������ݼ���������������
load('MLC5.mat');
load('LabCParams.mat');

% ʵ������
opts = InitOptions('clf', 1, []);
[ MyStat, MyTime, MyRank ] = MyStatistics(MLC5, CParams, Src, Dst, opts);
save('MyStat-MLC5.mat', 'MyStat', 'MyTime', 'MyRank');