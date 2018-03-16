images = '../images/Filter/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = ShapeSets;
% ������
Clf1 = KSVM(1136.5, 'rbf', 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clf7 = BP();
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6, Clf7};
% ����ѡ�񷽷�
Filters = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD', 'FNSSS', 'ENNC', 'BEPS'
};
% ʵ�������ݼ�������ѡ�񷽷�
DataSetIndices = [1 2 3 4 5 6];
FilterIndices = [1 2 3 4 5 6];
% ������
nD = length(DataSetIndices);
nM = length(FilterIndices);
Output = zeros(nD*nM, 5);
% ����ģ�Ͳ���
C = 1136.5;
Sigma = 3.6;
kFold = 10;
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
        % ѡ�������ݼ�����������֤
        fprintf('CrossValid:%s on reduced %s\n', Filters{j}, DataSet.Name);
        [ Accuracy, Precision, Recall ] = CrossValid( Clf3, DataSet.Data, kFold, C, Sigma  );
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T, Accuracy, Precision, Recall ];
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