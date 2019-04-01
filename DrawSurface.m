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
Path = './data/ssr/rbf/5-fold';
[ Result ] = GetParams(Path, DataSets, SParams{10}, [57],  {'Selected'});
BestParams = [Result.Result.BestParam];
%%
% file = sprintf('./results/paper3/RES_RBF_%s.mat', datestr(now, 'mmddHHMM'));
% save(file, 'Result');
%% 
function [ r ] = GetParams(Path, DataSets, SParams, IDX, INDICES)
    Result = [];
    for i = IDX
        File = sprintf('%s/SSRC_IRMTL-%s.mat', Path, DataSets(i).Name);
        d = load(File);
        Data = d.CVRate(:,1)./d.CVRate(:,2);
        [ s ] = GetBestParam(SParams, Data, INDICES, 'mu', 'C', true);
        s.DataSet = DataSets(i).Name;
        Result = cat(1, Result, s);
    end
    r.Result = Result;
    r.SParams = SParams;
end