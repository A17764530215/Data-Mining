images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DataSets = datas;

% �������ݼ�
% load([datasets, 'Datasets.mat'], 'Datasets');

% ����ѡ�񷽷�
Methods = {
    'ALL', 'NPPS', 'NDP', 'CBD', 'DSSM', 'KSSM'
};

ADD = ['FNSSS', 'ENNC', 'BEPS'];

% ����ģ�Ͳ���
C = 1136.5;
Sigma = 3.6;
kFold = 10;
% ������
nD = length(DataSets);
nM = length(Methods);
Output = zeros(nD*nM, 5);

% ����ͼ�����
h = figure('Visible', 'on');

% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = DataSets(i);
    D = DataSet.Data;
    [m, ~] = size(D);
    fprintf('%s:\n', DataSet.Name);
    % ��ÿһ������ѡ���㷨
    for j = 1 : nM
        % ��������ѡ��
        fprintf('Filter:%s on %s\n', Methods{j}, DataSet.Name);
        [D1, T] = Filter(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % ѡ�������ݼ�����������֤
        fprintf('CrossValid:%s on reduced %s\n', Methods{j}, DatasetNames{i});
        [ Accuracy, Precision, Recall ] = CrossValid( D1, kFold, C, Sigma  );
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T, Accuracy, Precision, Recall ];
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DataSet.Name, '.png']);
    clf(h);
end

% ��������ͼ
plot(Output);

% ����ͼ��
saveas(h, [images, 'runExperiments.png']);

% ������
csvwrite('runExperiments.csv', Output);
xlswrite('runExperiments.xls', Output);