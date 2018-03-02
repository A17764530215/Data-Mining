images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = datas;

% �������ݼ�
% load([datasets, 'Datasets.mat'], 'Datasets');

% ����ѡ�񷽷�
Methods = {
    'FNSSS', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD'
};

% ������
nD = length(DataSets);
nM = length(Methods);
Output = zeros(nD*nM, 2);

% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of five Algorithm on Three Datasets');

% ��ÿһ�����ݼ�
for i = 1 : nD
    clf(h);
    DataSet = DataSets(i);
    Data = DataSet.Data;
    Data = Data(1:1000,:);
    % ����ǩ�ŵ����һ�У�����ͳһִ��
    Data = DataLabel(Data, LabelIndex(i));
    [m, ~] = size(Data);
    % ��ÿһ������ѡ���㷨
    for j = 1 : nM
        % ��������ѡ��
        fprintf('Filter:%s on %s\n', Methods{j}, DatasetNames{i});
        [D1, T] = Filter(Data, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % �����������
        Output(sub2ind([nM, nD], j, i), :) = [SelectRate, T];
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, 'Filter-', DataSet.Name, '.png']);
end

% ������
csvwrite('runFilter.csv', Output);
xlswrite('runFilter.xls', Output);