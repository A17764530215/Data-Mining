%% 多分类数据集
load('LabMCL.mat');
Datasets = [];
for i = 1 : 14
    D = LabMCL(i);
    nclass = length(D.Labels);
    opts = struct('nclass', nclass, 'labels', D.Labels, 'count', 0, 'mode', 'RvO');
    [ Xr, Yr ] = MC2MT(D.X, D.Y, opts);
    Dataset = MyReduce(Xr, Yr, D.Name, 1:nclass-1, [0,1], 0, true, 3);
    Datasets = cat(1, Datasets, Dataset);
end

%% 合并所有数据集
% 五折
load('MLC5.mat');
load('Caltech5.mat');
load('MTL5.mat');
load('MTL_UCI5.mat');
DataSets = {MTL_UCI5;Caltech5;MLC5;MTL5};
DataSets = cellcat(DataSets, 1);
save DATA5.mat DataSets;
% 三折
load('MTL_UCI.mat');
load('Caltech.mat');
DataSets = {MTL_UCI;Caltech};
DataSets = cellcat(DataSets, 1);
save DATA3.mat DataSets;

%% 选取数据集
load('DATA5.mat');
IDX = [1:9 18:22 10 23 47 54 55 56 57 33:42 ];
DataSets = DataSets(IDX);
save DATA5R.mat DataSets;

%%
A = rand(100, 20);
kernel = struct('type', 'rbf', 'p1', 64);
H = Kernel(A, A, kernel);
% H2 = (H2+H2')/2;
tic
T = chol(H, 'upper');
toc;
% sigma = 0.2;
% x = 0:0.1:10;
% y = exp(-x.^2/(2*sigma^2));
% plot(x, y);
%% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

%% 创建目录
mkdir('./results/paper1/');
mkdir('./results/paper2/');
mkdir('./results/paper3/');