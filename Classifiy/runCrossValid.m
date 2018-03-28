images = '../images/MultiClf/KTWSVM';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ���������
Clf1 = CSVM(1136.5, 'rbf', 1136.5, 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clf = Clf5;
% ������
nD = length(DataSetIndices);
Output = cell(nD, 8);
% ������ͼģʽ
% h = figure('Visible', 'on');
fprintf('runCrossValid\n');
% ��ʼʵ��
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

% ������
xlswrite('runCrossValid.mat', Table);
writetable(table, 'runCrossValid.mat', 'WriteVariableNames', 1);