images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = datas;

% ������
nD = length(Datasets);

% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = DataSets{i};
    % �����������ݱ�ǩ��˳��
    D = DataLabel(DataSet.data, DataSet.LabelColumn);
    % LVQ
    [X, Y] = SplitDataLabel(D);
    [ P, t ] = LVQ( X, Y, DataSet.LabelNumber, 0.5, 40000 );
    lv = [P, t];
    % KMeans
    [Y, V] = KMeans(X, DataSet.LabelNumber);
    % ����ԭʼ���ݼ�
    PlotMultiClass(D, DataSet.Name, nD, 3, i*3-2, 6, Colors);
    % ����lv
    PlotMultiClass(lv, DataSet.Name, nD, 3, i*3-1, 12, Colors);
    % ���ƾ������� 
    PlotMultiClass(V, DataSet.Name, nD, 3, i*3, 12, Colors);
end