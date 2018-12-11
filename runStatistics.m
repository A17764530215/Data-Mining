clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0);
% �˺���
kernel = 'Poly';
switch(kernel)
    case 'Poly'
        Src = './data/classify/poly/';
        Dst = './lab/classify/poly/';
        load('LabCParams-Poly.mat');
    otherwise
        Src = './data/classify/rbf/';
        Dst = './lab/classify/rbf/';
        load('LabCParams.mat');
end

% ͳ��ʵ������
datasets = {'Caltech5', 'MTL_UCI5', 'MLC5'};
for i = 1 : length(datasets)
    load(datasets{i});
    [ MyStat, MyTime, MyRank ] = MyStatistics(eval(datasets{i}), CParams, Src, Dst, opts);
    path = ['MyStat-', datasets{i}, '-', kernel, '.mat'];
    save(path, 'MyStat', 'MyTime', 'MyRank');
    fprintf(['save: ', path, '\n']);
end