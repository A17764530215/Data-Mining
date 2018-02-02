images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'LR', 'wine', 'wine-quality-red', 'wine-quality-white', 'wifilocalization'
};
% ���ݼ�
Datasets = { LR, wine, winequalityred, winequalitywhite, wifilocalization };
% ���ݼ���ǩ������
LabelColumn = [3, 1, 12, 12, 8];
% ���ݼ�������
LabelNumber = [2, 3, 6, 7, 4];
% ��ɫ�б�
Colors = [ 
    255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255; ...
    255 128 0; 255 0 128; 128 0 255; 128 255 0; 0 255 128; 0 128 255 ...
];
Colors = Colors / 255;

% ������
Range = [1 2 3];
nD = length(Range);

% ����ͼ�����
h = figure('Visible', 'on');
title('Performance of Clustering');

% ��ÿһ�����ݼ�
for i = Range
    D = Datasets{i};
    % �����������ݱ�ǩ��˳��
    D = DataLabel(D, LabelColumn(i));
    % ����
    [ X, YTrue ] = SplitDataLabel(D);
    tic;
%     [ C, V ] = KMeans(X, LabelNumber(i));
    [ C ] = AGNES( X,  LabelNumber(i), 'min' );
    Time = toc;
    CorrectRate = mean(C==YTrue);
    fprintf('Dataset:%s\t%4.5f\t%d\n', DatasetNames{i}, CorrectRate, Time);
    % ����ԭʼ���ݼ�
    PlotMultiClass(D, DatasetNames{i}, nD, 2, i*2-1, 6, Colors);
    % ���ƾ�����
    D1 = [X, C];
    PlotMultiClass(D1, DatasetNames{i}, nD, 2, i*2, 6, Colors);
    % ���ƾ�������
%     PlotMultiClass(V, DatasetNames{i}, nD, 2, i*2, 32, Colors);
end
saveas(h, [images, 'runClustering-AGNES.png']);