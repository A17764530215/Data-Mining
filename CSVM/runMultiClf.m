images = '../images/MultiClf/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 8 9 12 13];
% ������
nD = length(DataSetIndices);
Output = cell(nD, 6);
% ���������
% clf = SVM('rbf', 1136.5, 12);
Clf = CSVM(1136.5, 3.6);
% clf = TWSVM(1.2, 1.2);

% ������ͼģʽ
h = figure('Visible', 'on');
for i = 1 : nD
    DataSet = DataSets(DataSetIndices(i));
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.35);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    fprintf('MultiClf...\n');
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    fprintf('Fit...\n');
    [Clfs, Time] = Clfs.Fit(XTrain, YTrain);
    fprintf('Predict...\n');
    [yTest] = Clfs.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(i, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Time
    };
    fprintf('PlotMultiClass...\n');
    
    clf(h);
    PlotMultiClass(DTrain, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Train.png']);
    savefig(h, [images, DataSet.Name, '-Train.fig']);
    clf(h);
    PlotMultiClass(DTest, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Test.png']);
    savefig(h, [images, DataSet.Name, '-Test.fig']);
    clf(h);
    PlotMultiClass(D1, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Predict.png']);
    savefig(h, [images, DataSet.Name, '-Predict.fig']);
end

% ������
Table = cell2table(Output, 'VariableNames', {'DataSet', 'Instances', 'Attributes', 'Classes', 'Accuracy', 'Time'});
% csvwrite('runMultiClf.csv', Output);
% xlswrite('runMultiClf.xls', Output);