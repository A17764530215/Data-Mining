images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% �������ݼ�
load([datasets, 'Datasets.mat'], 'Datasets');

% ����ѡ�񷽷�
Methods = {
    'NPPS', 'NDP', 'FNSSS', 'DSSM', 'KSSM'
};

% ����ģ�Ͳ���
C = 1136.5;
Sigma = 3.6;
% ������
nD = length(Datasets);
nM = length(Methods);
Output = zeros(nD*nM, 12);

% ����ͼ�����
h = figure('Visible', 'on');

% ��ÿһ�����ݼ�
for i = 1 : length(Datasets)
    D = Datasets{i};
    [m, ~] = size(D);
    fprintf('%s:\n', DatasetNames{i});
    % ����ѡ��ǰ�������
    PlotDataset(D, 3, 2, 1, 'ALL', 6, 'xr', '+g');
    % ��ÿһ������ѡ���㷨
    for j = 1 : length(Methods)
        % ��������ѡ��
        [D1, T] = SSMWrapper(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % ��ԭʼ���ݼ���ѡ�������ݼ�����������֤
        [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D, n, C, Sigma  );
        CV1 = [ Recall, Precision, Accuracy, FAR, FDR ];
        [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D1, n, C, Sigma  );
        CV2 = [ Recall, Precision, Accuracy, FAR, FDR ];
        % �����������
        Output(i*j, :) = [SelectRate, T, CV1, CV2];
        % ��������ѡ����
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DatasetNames{i}, '.png']);
    clf(h);
end

% ��������ͼ
plot(Output);

% ������
csvwrite('runExperiments.txt', Output);