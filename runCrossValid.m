cv = './cv/';
images = './images/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTL_Small.mat');
load('LabCParams.mat');

% ���ݼ�
DataSetIndices = [1 2 3];
ParamIndices = [3:9];
BestParams = 1;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver, 'Statistics', @ClfStat, 'IndexCount', 1);

% ʵ�鿪ʼ
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = LabClf(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetClfMTL(DataSet);
%     [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = CParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [cv, Name, '.mat'];
%         try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params, opts);
            save(StatPath, 'CVStat');
            fprintf('save: %s\n', StatPath);
%         catch Exception
%             fprintf('Exception in %s\n', Name);
%         end
    end
end