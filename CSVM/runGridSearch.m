images = '../images/CSVM/';

% ���ݼ�����
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% �������ݼ�
load([datasets, 'Datasets.mat'], 'Datasets');

% ȡ��һ�����ݼ�ǰ400��������ʵ��
D = Datasets{1};
D = D(1:1000,:);
% ��������
C = -3:1:3;
Sigma = 2:1:6;
% ��������
[ Output ] = GridSearch( D, 10, 2.^C, 2.^Sigma );

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