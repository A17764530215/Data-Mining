addpath(genpath(Src));
%%
clear
clc

kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/ssr/poly/'];
        load('LabSParams-Poly.mat');
    otherwise
        Src = ['./data/ssr/rbf/'];
        load('LabSParams.mat');
end

load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');

DataSets = [MTL_UCI5; Caltech5; MLC5];
IParams = CreateParams(SParams{4});
Params = struct2cell(IParams)';
INDICES = [ 2:9 1 10:15];
%% IRMTL_C
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{1}, SParams{2});

%% IRMTL_M
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{3}, SParams{4});

%%
labels = {'Screening Rate', 'Speed Up'};

plot(1:9, State([2:9 1], [8 9]));
xlabel('Task Size');
ylabel('Rate');
legend(labels, 'Location', 'northwest');
xTickLabel = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', 0);
%%
% EE = Result{44,1};
% IDX = find(EE(:,2)~=EE(:,1));
% ErrorParams = IParams(IDX);
% E=EE(IDX,:);
% 