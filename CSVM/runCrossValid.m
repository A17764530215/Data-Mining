images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�����
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% �������ݼ�
load([datasets, 'Datasets.mat'], 'Datasets');
n = length(DatasetNames);

% ���ļ�
fprintf('Datasets\tAccuracy\tRecall\tPrecision\tTime(s)\n');

% ������ͼģʽ
fprintf('runCrossValid');
h = figure('Visible', 'on');

% ����ģ�Ͳ���
C = 1136.5;
Sigma = 3.6;
Output = zeros(n, 5);
 
% ���������ݼ��ϲ���
for i = 1 : n
    D = Datasets{i};
    fprintf('CrossValid: on %s\n', DatasetNames{i});
    Output(i, :) = CrossValid( D, n, C, Sigma );
end

% ��������ͼ
bar(Output);

% ������
csvwrite('runCrossValid.txt', Output);