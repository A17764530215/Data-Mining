clc
clear
load('DATA5.mat');
load('LabCParams.mat');
load('LabSParams.mat');

%% MTvTWSVM
Stat = mean(CVStat, 3);
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
[ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(CParams{7}, Stat, INDICES, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');

%% SSRC_IRMTL
BestParams = [];
for i =[ 57 ]
    Path = sprintf('./data/ssr/rbf/5-fold/SSRC_IRMTL-%s.mat', DataSets(i).Name);
    load(Path);
    INDICES = {'Selected'};
    Rate = CVRate(:,1)./CVRate(:,2);
    [ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(SParams{6}, Rate, INDICES, 'mu', 'C');
    BestParam.DataSet = DataSets(i).Name;
    BestParams = cat(1, BestParams, BestParam);
end