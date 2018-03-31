images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./filter'));
addpath(genpath('./clustering'));
addpath(genpath('./datasets'));
addpath(genpath('./utils'));

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
    % ���ö����ѡ��
    opts.Classes = DataSet.Classes;
    opts.Labels = DataSet.Labels;
    opts.Mode = 'OvO';
    % ��ÿһ��ʵ�����
    for j = 1 : nP
        % ѡ��ʵ�����
        Params = IParams{j};
        % ����������������֤
        Outputs = GridSearchCV(@MultiClf, X, Y, Kfold, ValInd, Params, opts);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);