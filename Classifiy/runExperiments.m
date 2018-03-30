images = '../images/Filter/';
datasets = '../datasets/artificial/';

addpath(genpath('./model'));
addpath(genpath('./filter'));
addpath(genpath('./clustering'));

% ���ݼ�
DataSets = Artificial;
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
    % �ָ�������ǩ
    [X, Y] = SplitDataLabel(DataSet.Data);
    % ������֤����
    ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, 5 );
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
        % ѡ�������ݼ��������������ͽ�����֤
        fprintf('GridSearchCV:%s on reduced %s\n', Filters{j}, DataSet.Name);
        GridSearchCV(@MultiClf, X, Y, kFold, ValInd, Params, opts);
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