Path = './data/classify/rbf/';
load('LabCParams.mat');

%% �õ�����
Param = CParams{7};
[ BestParam, Accuracy, L, R ] = GetBestParam(Param, CVStat, 'rho', 'v1');