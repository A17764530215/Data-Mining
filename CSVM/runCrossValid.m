images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% ���ݼ�
DataSets = datas;

% �������ݼ�
% load([datasets, 'DataSets.mat'], 'Datasets');

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
    DataSet = DataSets(i);
    fprintf('CrossValid: on %s\n', DataSet.Name);
    Output(i, :) = CrossValid( DataSet.Data, 10, C, Sigma );
end

% ��������ͼ
bar(Output);

% ������
csvwrite('runCrossValid.txt', Output);