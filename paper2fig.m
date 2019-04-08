clear
clc
%%
Summary.Data = Summary.Data*100;
Summary.Time = Summary.Time*1000;
%% Classify Accuracy
[ d ] = Classify();
[ d ] = SetPaper3(d);
[ m, ~, k ] = size(Summary.Data);
Data = mat2cell(Summary.Data, m, d.Counts, k);
[ Info ] = Transform(Data, d, 1);
BatchDraw(Info, [1 7 8 2 3 4 5 6 9]);

%% Classify Time
[ d ] = Classify();
[ d ] = SetPaper3(d);
[ m, n, k ] = size(Summary.Time);
Data = mat2cell(Summary.Time, m, d.Counts, k);
[ Info ] = Transform(Data, d, 1);
BatchDraw(Info, [1 7 8 2 3 4 5 6 9]);

%% Safe Screening
[ d ] = SafeScreening();
Data = mat2cell(Summary.State', length(d.Legends), d.Counts);
[ Info ] = Transform(Data, d, 1);
BatchDraw(Info, [1 7 8 2 3 4 5 6 9]);

%% ���ɸѡ����
load('./results/paper3/MyStat-SSR-Linear.mat');
Curve(Summary, [1:57], [6 7], 'linear', 'rate');
Curve(Summary, [1:57], [8 9], 'linear', 'speed');
load('./results/paper3/MyStat-SSR-Poly.mat');
Curve(Summary, [1:57], [6 7], 'poly', 'rate');
Curve(Summary, [1:57], [8 9], 'poly', 'speed');
load('./results/paper3/MyStat-SSR-RBF.mat');
Curve(Summary, [1:57], [6 7], 'rbf', 'rate');
Curve(Summary, [1:57], [8 9], 'rbf', 'speed');

% ת����ʽ
function [ Summary ] = Transform(Data, d, k)
    xTickLabels = mat2cell(d.XTicklabel', d.Counts);
    Summary = [ ];
    for i = 1 : length(d.Titles)
        data = Data{i};
        s.Draw = d.Draws{i};
        s.Grid = d.Grids{i};
        s.Title = d.Titles{i};
        s.XLabel = d.xLabels{i};
        s.YLabel = d.yLabels{k};
        s.XTicklabels = xTickLabels{i};
        s.Legends = d.Legends(d.STL);
        s.Arc = d.Arcs(i);
        s.Stat = data(d.STL,:,k);
        Summary = cat(1, Summary, s);
    end
end

% ����
function [ d ] = SetPaper1(d)
    d.Legends = {
        'SVM','PSVM','LS-SVM',...
        'TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
        'RMTL','MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
        'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
    };
    d.MTL = [8:14];
    d.STL = [1:6 14];
end

function [ d ] = SetPaper2(d)
    d.Legends = {
        'SVM','PSVM','LS-SVM',...
        'TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
        'RMTL','MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
        'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
    };
    d.MTL = [8:13 15 16];
    d.STL = [1:6 15 16];
end

function [ d ] = SetPaper3(d)
    d.Legends = {
        'SVM','PSVM','LS-SVM','TWSVM',...
        'MTPSVM','MTLS-SVM','IRMTL', 'SSR-IRMTL',...
        'DMTSVM','SSR_DMTSVM'
    };
    d.STL = [ 1 2 3 4 5 6 7 8 9 ];
end

% ����
function [ d ] = Classify()
    d.Arcs = [0,0,0,0,45,45,0,0,0];
    d.Counts = [ 9, 8, 5, 5, 5, 10, 6, 6, 3, ];
    d.Draws = {@bar, @bar, @bar, @bar, @bar, @bar, @bar, @bar,@bar };
    d.Grids = {'off', 'off', 'off', 'off', 'off', 'off', 'off', 'off', 'off'};
    d.IndexCount = 8;
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech 101', 'Caltech 256', 'Flags', 'Emotions', 'MTL'};
    d.xLabels = { 'Task Size', 'Dataset Index', '#Task', 'Dataset Index', 'Category', 'Category',  'Task Size', 'Task Size', 'Dataset Index'};
    d.XTicklabel = {
        '60', '90', '120', '150', '180', '210', '240', '270', 'All',...
        'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op',...
        '3', '5', '7', '9', '11',...
        'T1', 'T2', 'T3', 'T4', 'T5',...
        'Birds','Insects','Flowers','Mammals','Instruments',...
        'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles',...
        '100', '120', '140', '160', '180', '191',...
        '100', '120', '140', '160', '180', '200',...
        'Letter', 'Spam_{3}', 'Spam_{15}'
    };
    d.yLabels = {'Accuracy', 'Precision', 'Recall', 'F1'};
end

function [ d ] = SafeScreening()
    d.Arcs = [0,0,0,0,45,45,0,0,0];
    d.Counts = [ 9, 8, 5, 5, 5, 10, 6, 6, 3 ];
    d.Draws = {@plot, @bar, @plot, @bar, @bar, @bar, @plot, @plot,@bar };
    d.Grids = {'on', 'off', 'on', 'off', 'off', 'off', 'on', 'on', 'off'};
    d.IndexCount = 7;
    d.Legends = {
        'S0', 'SC', 'C0', 'CC', 'Inactive', 'Screening', 'Speedup'
    };
    d.STL = [5 6];
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech 101', 'Caltech 256', 'Flags', 'Emotions', 'MTL'};
    d.xLabels = { 'Task Size', 'Dataset Index', '#Task', 'Dataset Index', 'Category', 'Category',  'Task Size', 'Task Size', 'Dataset'};
    d.XTicklabel = {
        '60', '90', '120', '150', '180', '210', '240', '270', 'All',...
        'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op',...
        '3', '5', '7', '9', '11',...
        'T1', 'T2', 'T3', 'T4', 'T5',...
        'Birds','Insects','Flowers','Mammals','Instruments',...
        'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles',...
        '100', '120', '140', '160', '180', '191',...
        '100', '120', '140', '160', '180', '200',...
        'Letter', 'Spam_{3}', 'Spam_{15}'
    };
    d.yLabels = {'Rate'};
end

% ��ͼ
function [] = Curve(Summary, INDICES, IDX, Kernel, Name)
    for i = INDICES
        if ~isempty(Summary.Result{i, 1})
            clf;
            plot(Summary.Result{i, 1}(:,IDX));
            path = sprintf('./figures/paper3/index/pic_%s_%s-%d.png', Kernel, Name,  i);
            saveas(gcf, path);
        end
    end
end

function [ ] = BatchDraw(Summary, IDX)
    figure();
    i = 1;
    for p = IDX
        subplot(3, 3, i);
        DrawResult(Summary(p));
        hold on
        i = i + 1;
    end
end

function [ ] = DrawResult(s)
%DRAWRESULT �˴���ʾ�йش˺�����ժҪ
% ����ʵ����
%   �˴���ʾ��ϸ˵��
    s.Draw(s.Stat');
    title(s.Title)
    xlabel(s.XLabel);
    ylabel(s.YLabel);
    legend(s.Legends, 'Location', 'northwest');
    grid(s.Grid);
    set(gca, 'XTicklabel', s.XTicklabels, 'XTickLabelRotation', s.Arc);
end