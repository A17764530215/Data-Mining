clear;
clc;

% �������ݺͲ���
load('DATA5R.mat')
load('LabRParams.mat');
load('LabCParams.mat');
load('LabSParams.mat');

% �����ֺ˺�����ʵ��ֿ�
Kernels = {'Linear', 'Poly', 'RBF'};
RParams = reshape(RParams, 14, 3);
CParams = reshape(CParams, 16, 3);
SParams = reshape(SParams, 12, 3);

%% ͳ������
opts = InitOptions('clf', 1, [], 0, 3);
for i = 1 : 3
    [ Summary ] = MyStatistics(DataSets, SParams(:,i), 'ssr-old64', opts);
    Path = ['./results/paper3/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% ͳ�ư�ȫɸѡ

for i = 1 : 3
    Params = reshape(SParams(7:12,i), [2 3]);
    Src = sprintf('./data/ssr-old64/%s/5-fold/', lower(Kernels{i}));
    for k = 1:3
        p = Params{2,k};
        Path = sprintf('./results/paper3/statistics/MyStat-%s-%s.mat', p.ID , p.kernel.type);
        Compare(Src, Path, DataSets, [2 22], Params{1,k}, Params{2,k});
    end
end