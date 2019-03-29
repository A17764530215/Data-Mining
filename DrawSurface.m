clc
clear
load('DATA.mat');
Path = sprintf('./data/ssr/rbf/5-fold/SSRC_IRMTL-%s.mat', DataSets(9).Name);
load(Path);
%% MTvTWSVM
Stat = mean(CVStat, 3);
load('LabCParams.mat');
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
[ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(CParams{7}, Stat, INDICES, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');
%% SSRC_IRMTL
load('LabSParams.mat');
INDICES = {'Selected'};
Rate = CVRate(:,1)./CVRate(:,2);
[ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(SParams{2}, Rate, INDICES, 'C', 'mu');
xlabel('\mu');
ylabel('C');