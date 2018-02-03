images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'LR', 'wine', 'Immunotherapy', 'wine-quality-red', 'wine-quality-white', 'wifilocalization'
};
% ���ݼ�
Datasets = { LR, wine, Immunotherapy, winequalityred, winequalitywhite, wifilocalization };
% ���ݼ���ǩ������
LabelColumn = [3, 1, 8, 12, 12, 8];
% ���ݼ�������
LabelNumber = [2, 3, 2, 6, 7, 4];
% ��ɫ�б�
Colors = [ 
    255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255; ...
    255 128 0; 255 0 128; 128 0 255; 128 255 0; 0 255 128; 0 128 255 ...
];
Colors = Colors / 255;

% ���෽��
Methods = {
    'Initial', 'KMeans', 'BiKMeans'
};
% ������
Range = [1 2 3];
nD = length(Range);
nM = length(Methods);

% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of Clustering');

% ��ÿһ�����ݼ�
nIndex = 0;
for i = Range
    % ���ͼ��
    clf(h);
    % ���б��
    nIndex = nIndex + 1;
    D = Datasets{i};
    % �����������ݱ�ǩ��˳��
    D = DataLabel(D, LabelColumn(i));
    [ X, Y ] = SplitDataLabel(D);
    % ��ÿһ�־����㷨
    for j = 1 : nM
        % ���о���
        fprintf('Cluster:%s on %s\n', Methods{j}, DatasetNames{i});
        [C, V, Time] = Cluster(X, Y, Methods{j}, LabelNumber(i));
        CorrectRate = mean(C==Y);
        fprintf('Methods:%s\t%4.5f\t%d\n', Methods{i}, CorrectRate, Time);
        % ���ƾ�����
        S = [X, C];
        PlotMultiClass(S, Methods{j}, 2, 2, j, 6, Colors);
        % ���ƾ�������
        PlotMultiClass(V, Methods{j}, 2, 2, j, 32, Colors);
    end
    hold on;
    saveas(h, [images, 'Cluster-', DatasetNames{i}, '.png']);
end