images = './images/';
data = './data/';
% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
% �������ݼ���������������
load('LabUCIReg.mat');
load('LabParams.mat');
% ���ݼ�
DataSetIndices = [3];
ParamIndices = [4];
% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
% ʵ�鿪ʼ
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    opts = struct('solver', solver);
    for j = ParamIndices
        Method = OParams{j};
        [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, IParams{j}, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
        save([data, DataSet.Name, '-', Method.Name, '.mat'], 'Stat', 'CVStat');
    end
end