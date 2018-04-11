images = './images/';
data = './data/';

% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% �������ݼ���������������
load('LabMulti.mat');
load('LabIParams.mat');

% PSVR:28 params 0.04.
% TWSVR:82944 params 38.24.
% TWSVR_Xu:2304 params 0.35.
% MTL_PSVR:196 params 0.10.
% MTL_LS_SVR:196 params 0.14.
% MTL_TWSVR:2304 params 0.22.
% MTL_TWSVR_Xu:2304 params 0.13.
% MTL_TWSVR_Mei:64512 params 3.84.

% ���ݼ�
DataSetIndices = [3 4 10 11 12];
ParamIndices = [7];
BestParams = 1;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% ʵ�鿪ʼ
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = LabMulti(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [data, Name, '-Test.mat'];
%         try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params);
            save(StatPath, 'CVStat');
            fprintf('save: %s\n', StatPath);
%         catch Exception
%             fprintf('Exception in %s\n', Name);
%         end
    end
end