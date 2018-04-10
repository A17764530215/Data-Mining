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
ParamIndices = [5];
BestParams = 85;

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
        Method = OParams{j};
        Params = IParams{j}(BestParams);
        CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params);
        save([data, DataSet.Name, '-', Method.Name, '-Best.mat'], 'CVStat');
    end
end