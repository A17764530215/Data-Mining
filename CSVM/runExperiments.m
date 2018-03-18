images = '../images/Filter/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = Artificial;
% ������
Clf1 = KSVM(1.2, 'rbf', 1136.5);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5);
Clf7 = BP();
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6, Clf7};
% ����ѡ�񷽷�
Filters = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD', 'FNSSS', 'ENNC', 'BEPS'
};
% ʵ�������ݼ�������ѡ�񷽷�
DataSetIndices = [5 10 11];
FilterIndices = [1 2 3 4 5 6];
% ������
nD = length(DataSetIndices);
nM = length(FilterIndices);
Output = zeros(nD*nM, 6);
% ��������
P1 = -3:1:3;
P2 = 2:1:6;
P3 = 2:1:6;
kFold = 5;
% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of five Sample Selection Algorithm');

% ��ÿһ�����ݼ�
for i = 1 : nD
    clf(h);
    % ѡȡ���ݼ�
    DataSet = DataSets(DataSetIndices(i));
    Data = DataLabel(DataSet.Data, DataSet.LabelColumn);
    fprintf('%s:\n', DataSet.Name);
    % ��ÿһ������ѡ���㷨
    for j = 1 : nM
        % ����ѡ�񷽷�
        FilterName = Filters{FilterIndices(j)};
        % ��������ѡ��
        fprintf('Filter:%s on %s\n', FilterName, DataSet.Name);
        [D1, T] = Filter(Data, FilterName);
        [n, ~] = size(D1);
        SelectRate = n/Data.Instances;
        % �ָ�������ǩ
        [X, Y] = SplitDataLabel(DataSet.Data);
        % ������֤����
        ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, 5 );
        % ѡ�������ݼ��������������ͽ�����֤
        fprintf('GridSearchCV:%s on reduced %s\n', Filters{j}, DataSet.Name);
        GridSearchCV(Clf, X, Y, ValInd, kFold, P1, P2, P3);
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, Filters{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DataSet.Name, '.png']);
end

% ����ͼ��
saveas(h, [images, 'runExperiments.png']);

% ������
csvwrite('runExperiments.csv', Output);
xlswrite('runExperiments.xls', Output);