images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% ʵ�������ݼ�
DataSetIndices = [3 4];
ParamIndices = [1];

% ������
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, 8);

% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % ������������ݼ�
    [X, Y, ValInd] = MultiTask(DataSet, 4);
    % ������֤����
    opts = struct('Kfold', 5, 'ValInd', ValInd);
    % ��ÿһ��ʵ�����
    for j = 1 : nP
        % ����������������֤
        Output = GridSearchCV(@MTL, X, Y, IParams{j}, opts);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, Output
        };
    end
end

% save('runGridSearch.mat', Output);