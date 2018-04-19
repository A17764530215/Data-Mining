cv = './cv/';
images = './images/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabReg.mat');
load('LabIParams.mat');

% ���ݼ�
DataSetIndices = [3];
ParamIndices = [1:14];
BestParams = 18;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% ʵ�鿪ʼ
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = LabReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [cv, Name, '.mat'];
        try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params);
            save(StatPath, 'CVStat');
            fprintf('save: %s\n', StatPath);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end