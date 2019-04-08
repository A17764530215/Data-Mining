clear;
clc;

% 加载数据和参数
load('DATA5.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

% 将三种核函数的实验分开
Kernels = {'Linear', 'Poly', 'RBF'};
RParams = reshape(RParams, 14, 3);
CParams = reshape(CParams, 16, 3);
SParams = reshape(SParams, 10, 3);

%% 统计数据
opts = InitOptions('clf', 1, [], 0, 3);
for i = 1 : 3
    [ Summary ] = MyStatistics(DataSets, SParams(:,i), 'ssr', opts);
    Path = ['./results/paper3/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% 统计 CRMTL 安全筛选
for i = 1 : 3
    Src = sprintf('./data/ssr/%s/5-fold/', lower(Kernels{i}));
    [ Summary ] = Compare(Src, DataSets, 1:9, SParams{6,i}, SParams{7,i});
    Path = ['./results/paper3/MyStat-SSRC-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% 统计 IRMTL 安全筛选
for i = 1 : 3
    Src = sprintf('./data/ssr/%s/5-fold/', lower(Kernels{i}));
    [ Summary ] = Compare(Src, DataSets, 1:57, SParams{7,i}, SParams{8,i});
    Path = ['./results/paper3/MyStat-SSRI-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% 统计 DMTSVM 安全筛选
for i = 1 : 3
    Src = sprintf('./data/ssr/%s/5-fold/', lower(Kernels{i}));
    [ Summary ] = Compare(Src, DataSets, [1:57], SParams{9,i}, SParams{10,i});
    Path = ['./results/paper3/MyStat-SSRD-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end
