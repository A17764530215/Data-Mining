images = '../images/CSVM/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ���������
Clf1 = CSVM(1.2, 'rbf', 1136.5, 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
% ��������
C = -3:1:3;
P1 = 2:1:6;
% ������
nD = length(DataSetIndices);
Output = cell(nD, 8);
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
    % ��������
    % Output = GridSearch( Data, 10, P1, P2 );
    Output = GridSearchCV(Clf, X, Y, ValInd, k, P1, P2);
    
    % ������
    saveas(h, [images, 'runGridSearch.png']);
end

csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);