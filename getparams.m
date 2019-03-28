clc
clear
Path = './data/ssr/rbf/';
load([Path, '\5-fold\SSRC_IRMTL-Monk-All.mat']);
load('LabSParams.mat');
IDX = 2;
Result = CreateParams(SParams{IDX});
%% 得到参数
Stat = mean(CVStat, 3);
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(CParams{IDX}, Result, Stat, INDICES, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');
%% 得到参数 ssrc-irmtl
INDICES = {'Selected'};
Rate = CVRate(:,1)./CVRate(:,2);
[ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(SParams{IDX}, Result, Rate, INDICES, 'C', 'mu');
xlabel('\mu');
ylabel('C');