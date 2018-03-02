images = '../images/CSVM/';

% ���ݼ�����
DataSets = datas;

% �������ݼ�
% load([datasets, 'Datasets.mat'], 'Datasets');

% ȡ��һ�����ݼ�ǰ400��������ʵ��
DataSet = DataSets(1);
Data = DataSet.Data;
Data = Data(1:1000,:);
% ��������
C = -3:1:3;
Sigma = 2:1:6;
% ��������
[ Output ] = GridSearch( Data, 10, 2.^C, 2.^Sigma );

% ������ʽ
styles = {
    '-r', '-g', '-b', '-y', '-c'
};
% ��������ͼ
h = figure();
bar(Output);

saveas(h, [images, 'runGridSearch.png']);

% ������
csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);