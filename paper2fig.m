clear
clc
%% Classify
MyStat = MyStat*100;
MyTime = MyTime*1000;
[ d ] = Classify(MyStat);
[ STL_Summary ] = Pack(d.Stat, d.Titles, d.xLabels, d.yLabels, d.Legends, d.XTicklabel, d.IDX, d.STL, 1);
[ MTL_Summary ] = Pack(d.Stat, d.Titles, d.xLabels, d.yLabels, d.Legends, d.XTicklabel, d.IDX, d.MTL, 1);
BatchDraw(MTL_Summary)

%% SafeScreening
[ d ] = SafeScreening(State);

%%
[ SSRSummary ] = PackState(d.State, d.Titles, d.xLabels, d.yLabels, d.Legends, d.XTicklabel, d.IDX, d.STL, [1 2]);
  
function [ ] = BatchDraw(MTL_Summary)
    figure();
    i = 1;
    for p = [ 1, 5:8 ]
        subplot(2, 3, i);
        s = MTL_Summary(p);
        DrawResult(s.Stat, s.Title, s.XLabels, s.XTicklabels, s.YLabel, s.Legends);
        hold on
        i = i + 1;
    end
end

function [ d ] = Classify(MyStat)
    d.Stat = MyStat;
    d.yLabels = {'Accuracy', 'Precision', 'Recall', 'F1'};
    d.IDX = [ 9, 8, 5, 5, 5, 10, 6, 6 ];
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech_{101}', 'Caltech_{256}', 'Flags', 'Emotions'};
    d.xLabels = { 'Task Size', 'Dataset Index', '#Task', 'Dataset Index', 'Category', 'Category',  'Task Size', 'Task Size'};
    d.XTicklabel = {
        'All', '60', '90', '120', '150', '180', '210', '240', '270', ...
        'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op',...
        '3', '5', '7', '9', '11',...
        'T1', 'T2', 'T3', 'T4', 'T5',...
        'Birds','Insects','Flowers','Mammals','Instruments',...
        'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles',...
        '100', '120', '140', '160', '180', '191',...
        '100', '120', '140', '160', '180', '200'
    };
    d.Legends = {
        'SVM','PSVM','LS-SVM',...
        'TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
        'MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
        'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
    };
    d.STL = [1 2 3 4 5 6 14 15];
    d.MTL = [8:12 14 15];
    d.IndexCount = 8;
end

function [ d ] = SafeScreening(State)
    d.State = State;
    d.yLabels = {'Screening Rate', 'Speed Up'};
    d.IDX = [ 9, 8, 5, 5, 5, 10, 6, 6, 3 ];
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech_{101}', 'Caltech_{256}', 'Flags', 'Emotions', 'MTL'};
    d.xLabels = { 'Task Size', 'Dataset Index', '#Task', 'Dataset Index', 'Category', 'Category',  'Task Size', 'Task Size'};
    d.XTicklabel = {
        'All', '60', '90', '120', '150', '180', '210', '240', '270', ...
        'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op',...
        '3', '5', '7', '9', '11',...
        'T1', 'T2', 'T3', 'T4', 'T5',...
        'Birds','Insects','Flowers','Mammals','Instruments',...
        'Aircrafts','Balls','Bikes', 'Birds','Boats','Flowers', 'Instruments','Plants','Mammals', 'Vehicles',...
        '100', '120', '140', '160', '180', '191',...
        '100', '120', '140', '160', '180', '200',...
        'Letter', 'Spam_{3}', 'Spam_{15}'
    };
    d.Legends = {
        'IRMTL-C', 'SSR-IRMTL-C',...
        'IRMTL-\mu', 'SSR-IRMTL-\mu',...
    };
    d.STL = [1 2];
    d.MTL = [3 4];
    d.IndexCount = 2;
end

function [ Summary ] = PackState(State, Titles, xLabels, yLabels, Legends, XTicklabel, IDX, STL, k)
    [ ~, n ] = size(State);
    State = mat2cell(State, IDX, n);
    xTickLabels = mat2cell(XTicklabel', IDX);
    Summary = [ ];
    for i = 1 : length(Titles)
        data = State{i};
        [ s ] = PackSummary(Titles{i}, data(STL,:,k), xLabels{i}, yLabels{k}, xTickLabels{i}, Legends(STL));
        Summary = cat(1, Summary, s);
    end
end

function [ Summary ] = Pack(Stat, Titles, xLabels, yLabels, Legends, XTicklabel, IDX, STL, k)
    n = length(Legends);
    Data = mat2cell(Stat, n, IDX, 8);
    xTickLabels = mat2cell(XTicklabel', IDX);
    Summary = [ ];
    for i = 1 : length(Titles)
        data = Data{i};
        [ s ] = PackSummary(Titles{i}, data(STL,:,k), xLabels{i}, yLabels{k}, xTickLabels{i}, Legends(STL));
        Summary = cat(1, Summary, s);
    end
end

function [ d ] = PackSummary(Title, Stat, XLabels, YLabel, XTicklabels, Legends)
    d.Title = Title;
    d.XLabels = XLabels;
    d.YLabel = YLabel;
    d.XTicklabels = XTicklabels;
    d.Legends = Legends;
    d.Stat = Stat';
end

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