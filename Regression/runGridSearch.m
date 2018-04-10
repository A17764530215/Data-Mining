images = './images/';
data = './data/';
% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% �������ݼ���������������
load('LabUCIReg.mat');
load('LabIParams.mat');

% ���ݼ�
DataSetIndices = [3];
ParamIndices = [5];

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% ʵ�鿪ʼ
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
        save([data, DataSet.Name, '-', Method.Name, '.mat'], 'Stat', 'CVStat');
    end
end