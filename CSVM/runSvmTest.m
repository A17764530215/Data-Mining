images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% �������ݼ�
load([datasets, 'Datasets.mat'], 'Datasets');
nD = length(DatasetNames);

% ���������
% clf = SVM('rbf', 1136.5, 12);
% clf = CSVM(1136.5, 3.6);
clf = CSVM(1136.5, 3.6);

% ������
Output = zeros(nD, 2);

% ������ͼģʽ
h = figure('Visible', 'on');
for i = 1 : length(DatasetNames)
    fprintf('%s:\n', DatasetNames{i});
    D = Datasets{i};
    fprintf('SplitDataset\n');
    DTrain = D(1:1800, :);
    DTest = D(1801:2000, :);
    fprintf('SplitDataLabel\n');
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    fprintf('Fit...\n');
    [clf, Time] = clf.Fit(XTrain, YTrain);
    fprintf('Predict...\n');
    [clf, yTest] = clf.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(i, :) = [Accuracy, Time];
    fprintf('PlotDataset...\n');
    PlotDataset(D1, 3, 3, i*3, DatasetNames{i}, 6, 'xr', '+g');
    PlotDataset(DTest, 3, 3, i*3-1, DatasetNames{i}, 6, 'xr', '+g');
    PlotDataset(DTrain, 3, 3, i*3-2, DatasetNames{i}, 6, 'xr', '+g');
end

% ����ͼ��
saveas(h, [images, 'runSvmTest.png']);

% ������
csvwrite('runSvmTest.csv', Output);
xlswrite('runSvmTest.xls', Output);