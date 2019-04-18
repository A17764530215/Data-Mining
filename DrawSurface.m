%% MTvTWSVM
clc
clear
load('DATA5.mat');
load('LabCParams.mat');
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
Data = mean(Summary.Data, 3);
[ d ] = GetBestParam(CParams{7}, Data, INDICES, 'rho', 'v1', true);
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');

%% SSRC_IRMTL
clc
clear
load('DATA5.mat');
load('LabSParams.mat');
Path = './data/ssr/linear/5-fold';
[ Result1 ] = GetBestResult(Path, DataSets, SParams{8}, [1:9 18:21],  {'Accuracy'});
BestParams1 = [Result1.Result.BestParam];
% [ Result2 ] = GetBestRate(Path, DataSets, SParams{8}, [1:9 18:21],  {'Selected'});
% BestParams2 = [Result2.Result.BestParam];
DrawAccuracyRate(Result1, Result2, 'linear', [1:13]);
%%
function [ ] = DrawAccuracyRate(Result1, Result2, Kernel, IDX)
    figure();
    for i  = IDX
        clf;
        subplot(1, 2, 1);
        title('Accuracy');
        surf(Result1.Result(i).Z)
        hold on;
        subplot(1, 2, 2);
        title('Selected');
        surf(Result2.Result(i).Z);
        path = sprintf('./figures/paper3/index/pic_%s-%d.png', Kernel,  i);
        saveas(gcf, path);
    end
end
%%
% file = sprintf('./results/paper3/RES_RBF_%s.mat', datestr(now, 'mmddHHMM'));
% save(file, 'Result');
%% 
function [ r ] = GetBestResult(Path, DataSets, SParams, IDX, INDICES)
    Result = [];
    for i = IDX
        File = sprintf('%s/%s-%s.mat', Path, SParams.ID, DataSets(i).Name);
        d = load(File);
        [ s ] = GetBestParam(SParams, mean(d.CVStat, 3), INDICES, 'mu', 'C', false);
        [ s ] = GetBestParam(SParams, d.CVRate(:,1)./d.CVRate(:,2), INDICES, 'mu', 'C', false);
        
        s.DataSet = DataSets(i).Name;
        Result = cat(1, Result, s);
    end
    r.Result = Result;
    r.SParams = SParams;
end