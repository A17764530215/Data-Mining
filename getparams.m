Path = './data/classify/rbf/';

load([Path, 'MTvTWSVM2']);
load('LabCParams.mat');

%% �õ�����
Param = CParams{7};
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(Param, CVStat, 'rho', 'v1');