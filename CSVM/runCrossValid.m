images = '../images/MultiClf/KTWSVM';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ������
nD = length(DataSetIndices);
Output = cell(nD, 8);
% ���������
% Clf = SVM('rbf', 1136.5, 12);
% Clf = CSVM(1136.5, 3.6);
% Clf = TWSVM(1.2, 1.2);
Clf = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
% ������ͼģʽ
h = figure('Visible', 'on');

fprintf('runCrossValid\n');
% ���������ݼ��ϲ���
for i = 1 : nD
    % ѡ�����ݼ�
    DataSet = DataSets(DataSetIndices(i));
    fprintf('CrossValid: on %s\n', DataSet.Name);
    % ת���������
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % ������֤
    [ Accuracy, Precision, Recall, Time ] = CrossValid( Clfs, DataSet, 5 );
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
bar(Output);

% ������
csvwrite('runCrossValid.txt', Output);
xlswrite('runCrossValid.mat', Table);