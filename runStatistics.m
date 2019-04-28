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
CParams = reshape(CParams, 17, 3);
SParams = reshape(SParams, 14, 3);

%% ͳ������
opts = InitOptions('clf', 1, [], 0, 3);
for i = 1 : 3
    [ Summary ] = MyStatistics(DataSets, SParams(:,i), 'ssr', opts);
    Path = ['./results/paper3/MyStat-Stat-', Kernels{i}, '.mat'];
    save(Path, 'Summary');
end

%% ͳ�ư�ȫɸѡ
for i = 1 : 3
    Params = reshape(SParams(7:14,i), [2 4]);
    Src = sprintf('./data/ssr/%s/5-fold/', lower(Kernels{i}));
    for k = 1:4
        p = Params{2,k};
        Path = sprintf('./results/paper3/statistics/MyStat-%s-%s.mat', p.ID , p.kernel.type);
        Compare(Src, Path, DataSets, [2 22], Params{1,k}, Params{2,k});
    end
end