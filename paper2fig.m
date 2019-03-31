clear
clc
%%
MyStat = MyStat*100;
MyTime = MyTime*1000;
%% Classify
[ d ] = Classify();
[ m, n, k ] = size(MyStat);
Data = mat2cell(MyStat, m, d.IDX, k);
[ STL_Summary ] = Transform(Data, d, 1);
[ MTL_Summary ] = Transform(Data, d, 1);
BatchDraw(MTL_Summary)

%% SafeScreening
[ d ] = SafeScreening();
Data = mat2cell(Summary.State', length(d.Legends), d.IDX);
[ SSR_Summary ] = Transform(Data, d, 1);
BatchDraw(SSR_Summary);

% 转换格式
function [ Summary ] = Transform(Data, d, k)
    xTickLabels = mat2cell(d.XTicklabel', d.IDX);
    Summary = [ ];
    for i = 1 : length(d.Titles)
        data = Data{i};
        s.Draw = d.Draws{i};
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

% 配置
function [ d ] = Classify()
    d.Arcs = [0,0,0,0,45,45,0,0];
    d.Draws = {@bar, @bar, @bar, @bar, @bar, @bar,@bar, @bar,@bar };
    d.IDX = [ 9, 8, 5, 5, 5, 10, 6, 6 ];
    d.IndexCount = 8;
    d.Legends = {
        'SVM','PSVM','LS-SVM',...
        'TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
        'MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
        'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
    };
    d.MTL = [8:12 14 15];
    d.STL = [1 2 3 4 5 6 14 15];
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech 101', 'Caltech 256', 'Flags', 'Emotions'};
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
    d.yLabels = {'Accuracy', 'Precision', 'Recall', 'F1'};
end

function [ d ] = SafeScreening()
    d.Arcs = [0,0,0,0,45,45,0,0,0];
    d.Draws = {@plot, @bar, @plot, @bar, @bar, @bar,@plot, @plot,@bar };
    d.IDX = [ 9, 8, 5, 5, 5, 10, 6, 6, 3 ];
    d.IndexCount = 7;
    d.Legends = {
        'Count1', 'Count2', 'avg2/avg1', 'avg0', 'avg2', 'Screening Rate', 'Speed Up'
    };
    d.STL = [6 7];
    d.Titles = {'Monk', 'Isolet', 'Letter_1', 'Letter_2', 'Caltech 101', 'Caltech 256', 'Flags', 'Emotions', 'MTL'};
    d.xLabels = { 'Task Size', 'Dataset Index', '#Task', 'Dataset Index', 'Category', 'Category',  'Task Size', 'Task Size', 'Dataset'};
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
    d.yLabels = {'Rate'};
end

% draw
function [ ] = BatchDraw(Summary)
    figure();
    i = 1;
    for p = 1 : 8
        subplot(3, 3, i);
        DrawResult(Summary(p));
        hold on
        i = i + 1;
    end
end

function [ ] = DrawResult(s)
%DRAWRESULT 此处显示有关此函数的摘要
% 绘制实验结果
%   此处显示详细说明
    s.Draw(s.Stat');
    title(s.Title)
    xlabel(s.XLabel);
    ylabel(s.YLabel);
    legend(s.Legends, 'Location', 'northwest');
    set(gca, 'XTicklabel', s.XTicklabels, 'XTickLabelRotation', s.Arc);
end