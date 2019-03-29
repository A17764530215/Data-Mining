%%
clear
clc

kernel = 'Poly';
switch(kernel)
    case 'Linear'
        Src = ['./data/ssr/linear/'];
        addpath(genpath(Src));
        load('LabSParams-Linear.mat');
    case 'Poly'
        Src = ['./data/ssr/poly/'];
        addpath(genpath(Src));
        load('LabSParams-Poly.mat');
    otherwise
        Src = ['./data/ssr/rbf/'];
        addpath(genpath(Src));
        load('LabSParams.mat');
end

load('DATA.mat');
IParams = CreateParams(SParams{2});
Params = struct2cell(IParams)';

labels = {'Screening Rate', 'Speed Up'};
INDICES = [ 1 18:27 43:57 ];
IDX = [8 9];
%% IRMTL_C
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{1}, SParams{2});

%% IRMTL_M
[ Result, State, Error ] = Compare(DataSets, INDICES, SParams{3}, SParams{4});

%% Monk 30-270 All
h = figure();
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
subplot(3, 3, 1);
Curve('(a) Monk', 1:9, State([2:9 1], IDX), labels, xLabels);

%% Flags
xLabels = {'100', '120', '140', '160', '180', '191'};
subplot(3, 3, 2);
Curve('(b) Flags', 1:6, State(43:48, IDX), labels, xLabels);

% Emotions
xLabels = {'100', '120', '140', '160', '180', '200'};
subplot(3, 3, 3);
Curve('(c) Emotions', 1:6, State(49:54, IDX), labels, xLabels);

% Letter1
xLabels = {'T3', 'T5', 'T7', 'T9', 'T11'};
subplot(3, 3, 4);
Curve('(d) Letter-Recognition_1', 1:5, State(18:22, IDX), labels, xLabels);

% Letter2
xLabels = {'T1', 'T2', 'T3', 'T4', 'T5'};
subplot(3, 3, 5);
Bar('(e) Letter-Recognition_2', 1:5, State(23:27, IDX), labels, xLabels);

% MTL
xLabels = {'Letter', 'Spam_3', 'Spam_{15}'};
subplot(3, 3, 6);
Bar('(f) MTL', 1:3, State(55:57, IDX), labels, xLabels);

% Caltech 101
% xLabels = {'Birds','Insects','Flowers','Mammals','Instruments'};
% subplot(3, 3, 7);
% Bar('Caltech 101', 1:5, State(28:32, IDX), labels, xLabels, 45);

% Caltech 256
% xLabels = {'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles'};
% subplot(3, 3, 8);
% Bar('Caltech 256', 1:10, State(33:42, IDX), labels, xLabels, 45);

%%
EE = Result{44,1};
IDX = find(EE(:,2)~=EE(:,1));
ErrorParams = IParams(IDX);
E=EE(IDX,:);

function [ ] = Curve(Title, X, Y, labels, xTickLabel, arc)
    if nargin < 6
        arc = 0;
    end
    plot(X, Y);grid on;
    title(Title);
    xlabel('Task Size');
    ylabel('Rate (%)');
    legend(labels, 'Location', 'northeast');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
    hold on;
end

function [ ] = Bar(Title, X, Y, labels, xTickLabel, arc)
    if nargin < 6
        arc = 0;
    end
    bar(X, Y);grid on;
    title(Title);
    xlabel('Task Size');
    ylabel('Rate (%)');
    legend(labels, 'Location', 'northeast');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
    hold on;
end