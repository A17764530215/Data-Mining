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
kernel = 'Linear';
switch(kernel)
    case 'Linear'
        Src = ['./data/', type, '/linear/'];
        Dst = ['./lab/', type, '/linear/'];
        load('LabSParams-Linear.mat');
    case 'Poly'
        Src = ['./data/', type, '/poly/'];
        Dst = ['./lab/', type, '/poly/'];
        load('LabSParams-Poly.mat');
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
load('DATA.mat')
[ MyStat, MyTime, MyRank ] = MyStatistics(DataSets, SParams, Src, Dst, opts);
path = [Path, 'MyStat-', kernel, '.mat'];
save(path, 'MyStat', 'MyTime', 'MyRank');
fprintf(['save: ', path, '\n']);