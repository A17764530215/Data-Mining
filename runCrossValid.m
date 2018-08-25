Path = './cv/classify/rbf/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('MTL_UCI.mat');
load('LabCParams.mat');

DataSets = MTL_UCI;
IParams = CParams;

% ���ݼ�
DataSetIndices = [18];
ParamIndices = [1:11];
BestParams = 144;

% ʵ������
opts = InitOptions('clf', 1, []);

% ʵ�鿪ʼ
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    StatDir = [ Path, int2str(DataSet.Kfold) '-fold/' ];
    if exist(StatDir, 'dir') == 0
        mkdir(StatDir);
    end
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [StatDir, Name, '.mat'];
        try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            [ OStat, TStat ] = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params, opts);
            save(StatPath, 'OStat', 'TStat');
            fprintf('save: %s\n', StatPath);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end