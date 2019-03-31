h = figure();
%%
MyStat = MyStat*100;
MyTime = MyTime*1000;
%%
load('DATA5.mat');
load('LabCParams.mat');
labels = {
    'SVM','PSVM','LS-SVM','TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
    'MTPSVM','MTLS-SVM''MTL-aLS-SVM','DMTSVM','MCTSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'};
% ������ѧϰ
STL_IDX = [1 2 3 4 5 6 14 15];
% ������ѧϰ
MTL_IDX = [8:12 14 15];
CUR_IDX = MTL_IDX;
IDX = 1;
%% Monk
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
DrawResult(MyStat(CUR_IDX,[2:9,1],IDX)', MyTime(CUR_IDX,[2:9 1])', 'Task size', labels(CUR_IDX), xLabels);

%% ISOLET
xLabels = {'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op'};
DrawResult(MyStat(CUR_IDX,10:17,IDX)', MyTime(CUR_IDX,10:17)', 'Category', labels(CUR_IDX), xLabels);

%% Letter1
xLabels = {'3', '5', '7', '9', '11'};
DrawResult(MyStat(CUR_IDX,18:22,IDX)', MyTime(CUR_IDX,18:23)', 'Category', labels(CUR_IDX), xLabels);

%% Letter2
xLabels = {'T1', 'T2', 'T3', 'T4', 'T5'};
DrawResult(MyStat(CUR_IDX,23:27,IDX)', MyTime(CUR_IDX,23:27)', 'Category', labels(CUR_IDX), xLabels);

%% Caltech
xLabels = {'Birds_1','Insects_1','Flowers_1','Mammals_1','Instruments_1','Aircrafts','Balls','Bikes','Birds','Boats','Flowers','Instruments','Plants','Mammals','Vehicles'};
DrawResult(MyStat(CUR_IDX,:,IDX)', MyTime(CUR_IDX,:)', 'Category', labels(CUR_IDX), xLabels, 45);

%% Caltech101
xLabels = {'Birds','Insects','Flowers','Mammals','Instruments'};
DrawResult(MyStat(CUR_IDX,1:5,IDX)', MyTime(CUR_IDX,1:5)', 'Category', labels(CUR_IDX), xLabels, 45);

%% Caltech256
xLabels = {'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles'};
DrawResult(MyStat(CUR_IDX,6:15,IDX)', MyTime(CUR_IDX,6:15)', 'Category', labels(CUR_IDX), xLabels, 45);

%% Flags
xLabels = {'100', '120', '140', '160', '180', '191'};
DrawResult(MyStat(CUR_IDX,1:6,IDX)', MyTime(CUR_IDX,1:6)', 'Task size', labels(CUR_IDX), xLabels);

%% Emotions
xLabels = {'100', '120', '140', '160', '180', '200'};
DrawResult(MyStat(CUR_IDX,7:12,IDX)', MyTime(CUR_IDX,7:12)', 'Task size', labels(CUR_IDX), xLabels);

%% Flags-Each
xLabels = {'1', '2', '3', '4', '5', '6', '7'};
DrawResult(MyStat(CUR_IDX,1:7,IDX)', MyTime(CUR_IDX,1), 'Task index', labels(CUR_IDX), xLabels);

%% Emotions-Each
xLabels = {'1', '2', '3', '4', '5', '6'};
DrawResult(MyStat(CUR_IDX,1:6,IDX)', MyTime(CUR_IDX,1), labels(CUR_IDX), xLabels);