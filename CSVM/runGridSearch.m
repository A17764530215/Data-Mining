images = '../images/CSVM/GridSearch/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% �˺�������
Params0 = struct('kernel', 'rbf', 'p1', 2.^(1:1:6)');
% ������������������
Params1 = struct('Name', 'CSVM', 'C', (1:1:6)', 'Kernel', Params0);
Params2 = struct('Name', 'TWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)');
Params3 = struct('Name', 'KTWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)', 'Kernel', Params0);
Params4 = struct('Name', 'LSTWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)', 'Kernel', Params0);
Params5 = struct('Name', 'KNNSTWSVM', 'c1', (1:1:6)', 'c2', (1:1:6)', 'c3', (1:1:6)', 'c4', (1:1:6)', 'Kernel', Params0);
% ת��������
Params = {Params1,Params2,Params3,Params4,Params5};
% ������
Kfold = 5;
nD = length(DataSetIndices);
nP = length(Params);
Outputs = cell(nD, 8);
% ������ͼģʽ
h = figure('Visible', 'on');
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = DataSets(DataSetIndices(i));
    % ��ÿһ��ʵ�����
    for j = 1 : nP
        % �ָ�������ǩ
        [X, Y] = SplitDataLabel(DataSet.Data);
        % ������֤����
        ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, Kfold );
        % ��ʼ������
        IParams = Classifier.CreateParams(Params{j});
        % ���ݵ�һ�������ʼ����������
        Clf = Classifier.CreateClf(IParams(1));
        % ת���������
        Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
        % ����������������֤
        Outputs = GridSearchCV(Clfs, X, Y, ValInd, IParams, Kfold);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);