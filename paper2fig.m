clear
clc
load('LabSParams.mat');
SParams = reshape(SParams, 28, 3);
figure();

%% Paper1
[ d ] = DATA5({
    'SVM','PSVM','LS-SVM','TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
    'RMTL','MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
    'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
}, [9:13 14]);

%% Paper2
[ d ] = DATA5({
    'SVM','PSVM','LS-SVM','TWSVM','LS-TWSVM','\nu-TWSVM','ITWSVM',...
    'RMTL','MTPSVM','MTLS-SVM','MTL-aLS-SVM',...
    'DMTSVM','MCTSVM','MTLS_TWSVM','MT-\nu-TWSVM I','MT-\nu-TWSVM II'
}, [9:13 15 16]);

%% Paper3
[ d ] = DATA5R({
    'SVM','PSVM','LS-SVM','TWSVM','MTPSVM','MTLS-SVM',...
    'RMTL-L1','SSRL1-IRMTL','RMTL-L2','SSRL2-IRMTL','RMTL-L2','SSRL2-IRMTL',...
    'IRMTL-C','SSRC-IRMTL','IRMTL-M','SSRM-IRMTL','IRMTL-P','SSRP-IRMTL',...
    'CRMTL-C','SSRC-CRMTL','CRMTL-M','SSRM-CRMTL','CRMTL-P','SSRP-CRMTL',...
    'DMTSVMA_C','SSRC_DMTSVMA','DMTSVMA_M','SSRM_DMTSVMA'
}, [ 1 5 6 19 20 ]);

Kernels = {'Linear', 'Poly', 'RBF'};
type = {'data', 'time'};
for k = [3]
    Path = ['./results/paper3/MyStat-Stat-', Kernels{k}, '.mat'];
    load(Path);
    for i = 1 : 2
        clf;
        FigureFactory(type{i}, Summary, d, 1:4);
        path = sprintf('./results/paper3/figures/Figure-%s-%s', upper(type{i}), Kernels{k});
        saveas(gcf, [path, '.png']);
        saveas(gcf, path, 'fig');
        saveas(gcf, path, 'epsc');
    end
end

%% Safe screening
[ d ] = DATA5R({'S0', 'SC', 'C0', 'CC', 'Inactive', 'Screening', 'Speedup'}, [ 7 ]);
for i = [ 1 3 ]
    Params = reshape(SParams(19:24,i), [2 3]);
    for k = [ 1 : 3 ]
        p = Params{2,k};
        Name = sprintf('MyStat-%s-%s', p.ID , p.kernel.type);
        Path = sprintf('./results/paper3/statistics/%s.mat', Name);
        if exist(Path, 'file')
            load(Path);
            clf;
            FigureFactory('state', Summary, d, [1:4]);
            path = sprintf('./results/paper3/figures/%s', Name);
            saveas(gcf, [path, '.png']);
            saveas(gcf, path, 'fig');
            saveas(gcf, path, 'epsc');
            fprintf([path, '\n']);
        end
    end
end

%% 输出筛选曲线
Curve(Summary, [1:57], [6 7], 'rbf', 'rate');
Curve(Summary, [1:57], [8 9], 'rbf', 'speed');

function [ d ] = DATA5(legends, idx)
% 数据集属性
    d.Arcs = [0,0,0,0,45,45,0,0,0];
    d.Counts = [ 9, 8, 5, 5, 5, 10, 6, 6, 3 ];
    d.Draws = {@plot, @bar, @plot, @bar, @bar, @bar, @plot, @plot,@bar };
    d.Grids = {'on', 'off', 'on', 'off', 'off', 'off', 'on', 'on', 'off'};
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
    d.Legends = legends;
    d.STL = idx;
end

function [ d ] = DATA5R(legends, idx)
% 数据集属性
    d.Arcs = [0,0,45,45];
    d.Counts = [ 9, 5, 7, 10 ];
    d.Draws = {@plot, @plot, @bar, @bar };
    d.Grids = {'on', 'on', 'off', 'off'};
    d.Titles = {'Monk', 'Letter', 'MTL', 'Caltech 256'};
    d.xLabels = { 'Task Size', '#Tasks', 'Dataset', 'Category'};
    d.XTicklabel = {
        '60', '90', '120', '150', '180', '210', '240', '270', 'All',...
        '3', '5', '7', '9', '11',...
        'Isolet_5','Letter_5','Flags_7','Emotions_6','Letter_8', 'Spam_{3}', 'Spam_{15}',...
        'Birds_5','Insects_4','Flowers_3','Mammals_{10}','Instruments_6',...
        'Flowers_3', 'Instruments_5','Plants_4','Mammals_{10}', 'Vehicles_9'
    };
    d.Legends = legends;
    d.STL = idx;
%         'Aircrafts_5','Balls_5','Bikes_6', 'Birds_9','Boats_4',...
end

% 绘图
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
