Path = './data/ssr/rbf/';

load([Path, '\5-fold\SSR_IRMTL-Monk-S270.mat']);

load('LabCParams.mat');
Result = CreateParams(CParams{16});
%% 得到参数
Stat = mean(CVStat, 3);
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(CParams{16}, Result, Stat, INDICES, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');
%% 得到参数
INDICES = {'Selected', 'All'};
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(CParams{16}, Result, CVRate, INDICES, 'C', 'mu');
xlabel('C');
ylabel('\mu');