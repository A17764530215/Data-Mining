images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% ���ݼ�
DataSetIndices = [1 3 4];
ParamIndices = [1 2 3 4 5 6 7 8];
% ʵ������
TaskNum = 4;
Kfold = 5;
solver = []; % optimoptions('fmincon', 'Display', 'off');
% ������
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, nP);

% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % ������������ݼ�
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    [X, Y] = Normalize(X, Y);
    % ������֤����
    opts = struct('solver', solver);
    % ��ÿһ���㷨
    for j = 1 : nP
        % ����������������֤
        CVStat = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % ������������������֤�Ľ��
        Output = struct(DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat);
        Outputs(i, j) = Output;
    end
end

% save('runGridSearch.mat', Output);