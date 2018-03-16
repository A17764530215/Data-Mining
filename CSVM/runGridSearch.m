images = '../images/CSVM/GridSearch/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ���������
Clf1 = CSVM(1136.5, 'rbf', 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6};
Clf = Clfs(6);
% ��������
P1 = -3:1:3;
P2 = 2:1:6;
P3 = 2:1:6;
% ������
nD = length(DataSetIndices);
Outputs = cell(nD, 8);
% ������ͼģʽ
h = figure('Visible', 'on');
fprintf('runGridSearch\n');
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
%     [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, X, Y, ValInd, k );
%     Output(i) = [ Accuracy, Precision, Recall, Time ];
    % ��������
%     Output = GridSearch(Clf, X, Y, ValInd, k, 2.^P1, 2.^P2);
    % ����������������֤
    Output = GridSearchCV(Clf, X, Y, ValInd, k, 2.^P1, 2.^P2);
    % ������������������֤�Ľ��
    Outputs(1, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
    };
end

csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);