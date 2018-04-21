cv = './cv/';
images = './images/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLReg.mat');
load('LabRParams.mat');
DataSets = LabMTLReg;
IParams = RParams;

% ���ݼ�
DataSetIndices = [1];
ParamIndices = [1:14];
BestParams = 1;

% ʵ������
solver = [];
opts = struct('solver', solver, 'Statistics', @RegStat, 'IndexCount', 4);

% ʵ�鿪ʼ
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = LabMTLReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetClfMTL(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [cv, Name, '.mat'];
        try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params, opts);
            save(StatPath, 'CVStat');
            fprintf('save: %s\n', StatPath);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end