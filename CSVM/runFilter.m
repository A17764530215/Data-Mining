images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};
% ���ݼ���ǩ������
LabelIndex = [3, 3, 3];

% �������ݼ�
load([datasets, 'Datasets.mat'], 'Datasets');

% ����ѡ�񷽷�
Methods = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD'
};

% ������
nD = length(Datasets);
nM = length(Methods);
Output = zeros(nD*nM, 2);

% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of five Algorithm on Three Datasets');

% ��ÿһ�����ݼ�
for i = 1 : nD
    D = Datasets{i};
    D = D(1:1000,:);
    % ����ǩ�ŵ����һ�У�����ͳһִ��
    D = DataLabel(D, LabelIndex(i));
    [m, ~] = size(D);
    % ��ÿһ������ѡ���㷨
    for j = 1 : nM
        % ��������ѡ��
        fprintf('Filter:%s on %s\n', Methods{j}, DatasetNames{i});
        [D1, T] = Filter(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % �����������
        Output(sub2ind([nM, nD], j, i), :) = [SelectRate, T];
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DatasetNames{i}, '-Filter.png']);
    clf(h);
end

% ������
csvwrite('runFilter.csv', Output);
xlswrite('runFilter.xls', Output);