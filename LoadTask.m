%%
clear
clc
Src = './data/ssr/rbf/5-fold/';
load('LabSParams.mat');
load('DATA.mat');
INDICES = [ 1:27 43:57 ];
% INDICES = [ 28:42 ];

% IRMTL_C
[ Result, State, Error, ErrorParams, ErrorResult ] = Compare(Src, DataSets, INDICES, SParams{1}, SParams{2});

%% IRMTL_M
[ Result, State, Error, ErrorParams, ErrorResult ] = Compare(Src, DataSets, INDICES, SParams{3}, SParams{4});

%% »æÍ¼
h = figure();
labels = {'Screening Rate', 'Speed Up'};
IDX = [6 7];

% Monk
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
subplot(3, 4, 1);
Curve('(a) Monk', 1:9, State([2:9 1], IDX), labels, xLabels);

% Others
% xLabels = {'Isolet', 'Flags', 'Emotions', 'Letter', 'Spam_3', 'Spam_{15}'};
% subplot(2, 2, 2);
% Bar('(a) Monk', 1:6, State([10 48 54 55 56 57 ], IDX), labels, xLabels, 45);

% Flags
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
Bar('(d) Letter-Recognition_1', 1:5, State(18:22, IDX), labels, xLabels);

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

% % Caltech 256
% xLabels = {'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles'};
% subplot(3, 3, 8);
% Bar('Caltech 256', 1:10, State(33:42, IDX), labels, xLabels, 45);

function [ ] = Curve(Title, X, Y, labels, xTickLabel, arc)
    if nargin < 6
        arc = 0;
    end
    plot(X, Y*100);grid on;
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
    bar(X, Y*100);grid on;
    title(Title);
    xlabel('Task Size');
    ylabel('Rate (%)');
    legend(labels, 'Location', 'northeast');
    set(gca, 'XTicklabel', xTickLabel, 'XTickLabelRotation', arc);
    hold on;
end