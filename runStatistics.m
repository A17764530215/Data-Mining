clear;
clc;

% 加载数据和参数
load('DATA5R.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

% 将三种核函数的实验分开
Kernels = {'Linear', 'Poly', 'RBF'};
RParams = reshape(RParams, 14, 3);
CParams = reshape(CParams, 16, 3);
SParams = reshape(SParams, 20, 3);

%% 统计数据
opts = InitOptions('clf', 1, [], 0, 2);
for i = 1 : 3
    [ Summary ] = MyStatistics(DataSets, CParams(:,i), 'paper2', opts);
    Path = ['./results/paper2-new/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% 统计数据
opts = InitOptions('clf', 1, [], 0, 3);
for i = 1 : 3
    [ Summary ] = MyStatistics(DataSets, SParams(:,i), 'ssr-complete', opts);
    Path = ['./results/ssr-complete/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% 统计安全筛选
for i = 1 : 3
    Params = reshape(SParams(7:18,i), [2 6]);
    Src = sprintf('./data/ssr-complete/%s/5-fold/', lower(Kernels{i}));
    for k = 1:6
        p = Params{2,k};
        Path = sprintf('./results/ssr-complete/statistics/MyStat-%s-%s.mat', p.ID , p.kernel.type);
        Compare(Src, Path, DataSets, [1:31], Params{1,k}, Params{2,k});
    end
end