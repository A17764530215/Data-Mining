images = '../images/MultiClf/LSTWSVM/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2];% 4 6 7 8 9 12 13];
% ������
nD = length(DataSetIndices);
Output = cell(nD, 6);
% �����������

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
    % �ָ����ݼ�
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.80);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    % ѵ��
    fprintf('MultiClf %s Fit and Predict...\n', Clf.Name);
    opts.Classes =  DataSet.Classes;
    opts.Labels = DataSet.Labels;
    opts.
    [ yTest, Time ] = MultiClf(XTrain, YTrain, XTest, opts);
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