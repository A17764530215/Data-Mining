clear;
clc;

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݺͲ���
load('DATA5.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

% �����ֺ˺�����ʵ��ֿ�
Kernels = {'Linear', 'Poly', 'RBF'};
RParams = mat2cell(RParams, [14, 14, 14]);
CParams = mat2cell(CParams, [16, 16, 16]);
SParams = mat2cell(SParams, [4, 4, 4]);

%% ͳ������
opts = InitOptions('clf', 1, [], 0, 3);
for i = 1 : 3
    [ MyStat, MyTime, MyRank, MyName ] = MyStatistics(DataSets, SParams{i}, 'ssr', opts);
    Path = ['./results/paper3/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'MyStat', 'MyTime', 'MyRank', 'MyName');
end

%% ͳ�ư�ȫɸѡ
for i = 1 : 3
    Params = SParams{i};
    Src = sprintf('./data/ssr/%s/5-fold/', lower(Kernels{i}));
    [ Summary ] = Compare(Src, DataSets, 1:57, Params{1}, Params{2});
    Path = ['./results/paper3/MyStat-SSR-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% ����Ŀ¼
mkdir('./results/paper1/');
mkdir('./results/paper2/');
mkdir('./results/paper3/');