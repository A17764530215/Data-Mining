images = '../images/MultiClf/KTWSVM';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ������
nD = length(DataSetIndices);
Output = zeros(nD, 4);
% ���������
% Clf = SVM('rbf', 1136.5, 12);
% Clf = CSVM(1136.5, 3.6);
% Clf = TWSVM(1.2, 1.2);
Clf = KTWSVM('rbf', 1.2, 1.2, 1136.5, 3.6);
% ������ͼģʽ
h = figure('Visible', 'on');

fprintf('runCrossValid\n');
% ���������ݼ��ϲ���
for i = 1 : nD
    % ѡ�����ݼ�
    DataSet = DataSets(DataSetIndices(i));
    fprintf('CrossValid: on %s\n', DataSet.Name);
    % ת���������
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % ������֤
    Output(i, :) = CrossValid(Clfs, DataSet.Data, 5);
end

% ��������ͼ
bar(Output);

% ������
csvwrite('runCrossValid.txt', Output);