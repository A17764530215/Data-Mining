images = '../images/CSVM/GridSearch/';

% ʵ�������ݼ�
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% �˺�������
RangeP1 = 2^(1:1:6)';
Params0 = struct('kernel', 'rbf', 'p1', RangeP1);
% ������������������
RangeC = 2^(1:1:6)';
RangeC1 = 2^(1:1:6)';
RangeC2 = 2^(1:1:6)';
Params1 = struct('Name', 'CSVM', 'C', RangeC, 'Kernel', Params0);
Params2 = struct('Name', 'TWSVM', 'C1', RangeC1, 'C2', RangeC2);
Params3 = struct('Name', 'KTWSVM', 'C1', RangeC1, 'C2', RangeC2, 'Kernel', Params0);
Params4 = struct('Name', 'LSTWSVM', 'C1', RangeC1, 'C2', 2^(1:1:6)', 'Kernel', Params0);
Params5 = struct('Name', 'KNNSTWSVM', 'c1', RangeC1, 'c2', RangeC2, 'c3', RangeC1, 'c4', RangeC12, 'Kernel', Params0);
% ת��������
Params = {Params1,Params2,Params3,Params4,Params5};
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
        % ��ʼ��������
        IParams = Classifier.CreateParams(Params{ParamIndices(j)});
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