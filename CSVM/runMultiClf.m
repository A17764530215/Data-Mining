images = '../images/MultiClf/LSTWSVM/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2];% 4 6 7 8 9 12 13];
% ������
nD = length(DataSetIndices);
Output = cell(nD, 6);
% �����������
% CLF1 = SVM(1136.5, 'rbf', 12);
Clf1 = KSVM(1136.5, 'rbf', 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clf7 = BP();
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6, Clf7};

% ������ͼģʽ
% h = figure('Visible', 'on');
fprintf('runMultiClf\n');
for j = 1 : nD
    % ѡ�����ݼ�
    DataSet = DataSets(DataSetIndices(j));
    % ��׼�����ݼ�
%     fprintf('Normalize %s:\n', DataSet.Name);
%     Data = Normalize(DataSet.Data, DataSet.LabelColumn);
    % ת���������
    fprintf('MultiClf...\n');
    Clf = MultiClf(Clfs{6}, DataSet.Classes, DataSet.Labels);
    % �ָ����ݼ�
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.80);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    % ѵ��
    fprintf('%s Fit...\n', Clf.Name);
    [Clf, Time] = Clf.Fit(XTrain, YTrain);
    % ����
    fprintf('Predict...\n');
    [yTest] = Clf.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(j, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Time
    };
    fprintf('PlotMultiClass...\n');
    % ��ͼ
%     PlotTrainTest( h, images, DataSet, D1, DTrain, DTest, Colors );
end

% ������
Table = cell2table(Output, 'VariableNames', {'DataSet', 'Instances', 'Attributes', 'Classes', 'Accuracy', 'Time'});
Table

% save([images, 'Table.mat'], Table);
% csvwrite('runMultiClf.csv', Output);
% xlswrite('runMultiClf.xls', Output);