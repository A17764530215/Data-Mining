%%
clear
clc

kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/ssr/poly/'];
        addpath(genpath(Src));
        load('LabSParams-Poly.mat');
    otherwise
        Src = ['./data/ssr/rbf/'];
        addpath(genpath(Src));
        load('LabSParams.mat');
end

load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');
load('MTL5.mat');

DataSets = [MTL_UCI5; Caltech5; MLC5; MTL5];
IParams = CreateParams(SParams{4});
Params = struct2cell(IParams)';

h = figure();
labels = {'Screening Rate', 'Speed Up'};
INDICES = [ 1:9 18:27 43:54 ];
IDX = [8 9];
%% IRMTL_C
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{1}, SParams{2});

%% IRMTL_M
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{3}, SParams{4});

%% Monk 30-270 All
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
subplot(2, 3, 1);
curve('(a) Monk', 1:9, State([2:9 1], IDX), labels, xLabels);

% Flags
xLabels = {'100', '120', '140', '160', '180', '191'};
subplot(2, 3, 2);
curve('(b) Flags', 1:6, State(43:48, IDX), labels, xLabels);

% Emotions
xLabels = {'100', '120', '140', '160', '180', '200'};
subplot(2, 3, 3);
curve('(c) Emotions', 1:6, State(49:54, IDX), labels, xLabels);

% Letter1
xLabels = {'T3', 'T5', 'T7', 'T9', 'T11'};
subplot(2, 3, 4);
curve('(d) Letter-Recognition_1', 1:5, State(18:22, IDX), labels, xLabels);

% Letter2
xLabels = {'T1', 'T2', 'T3', 'T4', 'T5'};
subplot(2, 3, 5);
curve('(e) Letter-Recognition_2', 1:5, State(23:27, IDX), labels, xLabels);

% Isolet
% xLabels = {'T1', 'T2', 'T3', 'T4'};
% subplot(2, 3, 6);
% curve('Isolet', 1:4, State(10:13, IDX), labels, xLabels);

%%
EE = Result{44,1};
IDX = find(EE(:,2)~=EE(:,1));
ErrorParams = IParams(IDX);
E=EE(IDX,:);

function [ ] = curve(Title, X, Y, labels, xTickLabel)
    plot(X, Y);grid on;
    title(Title);
    xlabel('Task Size');
    ylabel('Rate (%)');
    legend(labels, 'Location', 'northeast');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', 0);
    hold on;
end