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
    [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D(1:1000,:), n, C, Sigma );
    Output(i, :) = [ Recall, Precision, Accuracy, FAR, FDR ];
    fprintf('%s\t%8.5f\t%8.5f\t%8.5f\n', DatasetNames{i}, Accuracy, Recall, Precision);
end

% ��������ͼ
bar(Output);

% ������
csvwrite('runCrossValid.txt', Output);