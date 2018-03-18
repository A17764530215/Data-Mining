images = '../images/Filter/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = ShapeSets;
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
Output = zeros(nD*nM, 2);
% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of five Sample Selection Algorithm');
% ��ʾ���ݼ���Ϣ
PrintDataInfo(DataSets(DataSetIndices));
% ��ÿһ�����ݼ�
for i = 1 : nD
    clf(h);
    % ѡȡ���ݼ�
    DataSet = DataSets(DataSetIndices(i));
    Data = DataLabel(DataSet.Data(1:1000,:), DataSet.LabelColumn);
    fprintf('%s:\n', DataSet.Name);
    % ��ÿһ������ѡ���㷨
    for j = 1 : nM
        % ����ѡ�񷽷�
        FilterName = Filters{FilterIndices(j)};
        % ��������ѡ��
        fprintf('Filter:%s on %s\n', FilterName, DataSet.Name);        
        [D1, T] = Filter(Data, FilterName);
        [n, ~] = size(D1);
        SelectRate = n/DataSet.Instances;
        % �����������
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T ];
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, FilterName, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, 'Filter-', DataSet.Name, '.png']);
end

% ������
csvwrite('runFilter.csv', Output);
xlswrite('runFilter.xls', Output);