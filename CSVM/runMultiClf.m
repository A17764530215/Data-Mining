images = '../images/MultiClf/LSTWSVM/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6 7 8 9 12 13];
% ������
nD = length(DataSetIndices);
Output = cell(nD, 6);
% ���������
% Clf = SVM(1136.5, 'rbf', 12);
% Clf = KSVM(1136.5, 'rbf', 3.6);
% Clf = TWSVM(1.2, 1.2);
% Clf = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
% ������ͼģʽ
h = figure('Visible', 'on');

fprintf('runMultiClf\n');
for i = 1 : nD
    % ѡ�����ݼ�
    DataSet = DataSets(DataSetIndices(i));
    % ��׼�����ݼ�
%     fprintf('Normalize %s:\n', DataSet.Name);
%     Data = Normalize(DataSet.Data, DataSet.LabelColumn);
    % ת���������
    fprintf('MultiClf...\n');
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % �ָ����ݼ�    
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.80);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    % ѵ��
    fprintf('%s Fit...\n', Clfs.Name);
    [Clfs, Time] = Clfs.Fit(XTrain, YTrain);
    % ����
    fprintf('Predict...\n');
    [yTest] = Clfs.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(i, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Time
    };
    fprintf('PlotMultiClass...\n');
    % ��ͼ
%     clf(h);
%     PlotMultiClass(DTrain, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Train.png']);
%     savefig(h, [images, DataSet.Name, '-Train.fig']);
%     clf(h);
%     PlotMultiClass(DTest, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Test.png']);
%     savefig(h, [images, DataSet.Name, '-Test.fig']);
%     clf(h);
%     PlotMultiClass(D1, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Predict.png']);
%     savefig(h, [images, DataSet.Name, '-Predict.fig']);
end

% ������
Table = cell2table(Output, 'VariableNames', {'DataSet', 'Instances', 'Attributes', 'Classes', 'Accuracy', 'Time'});
Table

% save([images, 'Table.mat'], Table);
% csvwrite('runMultiClf.csv', Output);
% xlswrite('runMultiClf.xls', Output);