images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% ʵ�������ݼ�
DataSetIndices = [3 4];
ParamIndices = [1 2 3 4 5];

% ������
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, nP);
solver = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % ������������ݼ�
    [X, Y, ValInd] = MultiTask(DataSet, 4, 5);
    % ������֤����
    opts = struct('TaskNum', 4, 'Kfold', 5, 'ValInd', ValInd, 'solver', solver);
    % ��ÿһ���㷨
    for j = 1 : nP
        % ����������������֤
        CVStat = GridSearchCV(@MTL, X, Y, IParams{j}, opts);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat
        };
    end
end

% save('runGridSearch.mat', Output);