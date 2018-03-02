images = '../images/Cluster/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = datas;

% ���෽��
Methods = {
    'Initial', 'KMeans', 'BiKMeans', 'AGNES'
};

% ������
Range = [1 2 3 4 7 8 9];
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
    % ���ݼ�
    DataSet = DataSets(i);
    % �����������ݱ�ǩ��˳��
    D = DataLabel(DataSet.Data, DataSet.LabelColumn);
    [ X, Y ] = SplitDataLabel(D);
    % ��ÿһ�־����㷨
    for j = 1 : nM
        % ���о���
        fprintf('Cluster:%s on %s\n', Methods{j}, DataSet.Name);
        [C, V, Time] = Cluster(X, Y, Methods{j}, DataSet.LabelNumber);
        CorrectRate = mean(C==Y);
        fprintf('Methods:%s\t%4.5f\t%d\n', Methods{j}, CorrectRate, Time);
        % ���ƾ�����
        S = [X, C];
        PlotMultiClass(S, Methods{j}, 2, 2, j, 6, Colors);
        % ���ƾ�������
        PlotMultiClass(V, Methods{j}, 2, 2, j, 32, Colors);
    end
    hold on;
    saveas(h, [images, 'Cluster-', DataSet.Name, '.png']);
end