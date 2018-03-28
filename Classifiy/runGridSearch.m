images = '../images/CSVM/GridSearch/';

% ʵ�������ݼ�
load('Artificial.mat');
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% ʵ���������
load('LabIParams.mat');
IParams = LabIParams;
ParamIndices = [1 3 4];
% ������
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, 8);
% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = DataSets(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % �ָ�������ǩ
    [X, Y] = SplitDataLabel(DataSet.Data);
    % ������֤����
    ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, Kfold );
    % ��ÿһ��ʵ�����
    for j = 1 : nP
        % ѡ��ʵ�����
        Params = IParams{j};
        % ���ݵ�һ�������ʼ����������
        Clf = Classifier.CreateClf(Params(1));
        % ת���������
        Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
        % ����������������֤
        Outputs = GridSearchCV(Clfs, X, Y, ValInd, Params, Kfold);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);