images = '../images/MultiClf/KTWSVM';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ���������
Clf1 = CSVM(1.2, 'rbf', 1136.5, 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf = Clf3;
% ������
nD = length(DataSetIndices);
Output = cell(nD, 8);
% ������ͼģʽ
h = figure('Visible', 'on');
fprintf('runCrossValid\n');
% ���������ݼ��ϲ���
for i = 1 : nD
    % ѡ�����ݼ�
    DataSet = DataSets(DataSetIndices(i));
    % ת���������
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % �ָ�������ǩ
    [X, Y] = SplitDataLabel(DataSet.Data);
    % ������֤����
    ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, 5 );
    % ������֤
    [ Accuracy, Precision, Recall, Time ] = CrossValid( Clfs, X, Y, ValInd, 5 );
    % ������
    Output(i, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Precision, Recall, Time
    };
end

% ������
Table = cell2table(Output, 'VariableNames', {
    'DataSet', 'Instances', 'Attributes', 'Classes',...
    'Accuracy', 'Precision', 'Recall', 'Time'
});
Table

% ��������ͼ
bar(Output{:,5:8});

% ������
csvwrite('runCrossValid.txt', Output);
xlswrite('runCrossValid.mat', Table);