clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% ʵ������
opts = InitOptions('clf', 1, [], 0, 3);
% �˺���
types = {'classify', 'regression', 'ssr'};
type = types{3};
kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/', type, '/poly/'];
        Dst = ['./lab/', type, '/poly/'];
        load('LabCParams-Poly.mat');
    otherwise
        Src = ['./data/', type, '/rbf/'];
        Dst = ['./lab/', type, '/rbf/'];
        load('LabSParams.mat');
end

Path = ['./results/', type, '/'];
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% ͳ��ʵ������
datasets = {'Caltech5', 'MTL_UCI5', 'MLC5'};
for i = 1 : length(datasets)
    load(datasets{i});
    [ MyStat, MyTime, MyRank ] = MyStatistics(eval(datasets{i}), SParams, Src, Dst, opts);
    path = [Path, 'MyStat-', datasets{i}, '-', kernel, '.mat'];
    save(path, 'MyStat', 'MyTime', 'MyRank');
    fprintf(['save: ', path, '\n']);
end