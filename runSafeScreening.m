clc
clear

Path = './data/ssr/linear/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('DATA.mat');
load('LabSParams-Linear.mat');

% ���ݼ�
DataSetIndices = [ 1 ];
ParamIndices = [ 1:4 ];

%% ʵ������ RMTL
solver = struct('Display', 'off');
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% profile clear;
% profile on;
% ʵ�鿪ʼ
fprintf('runGridSearch\n');
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
        Method = SParams{j};
        Name = [Method.ID, '-', DataSet.Name];
        StatPath = [StatDir, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime, CVRate ] = SSR(X, Y, Method, DataSet.TaskNum, 1, ValInd, opts );
                save(StatPath, 'CVStat', 'CVTime', 'CVRate');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                delete('check-point.mat');
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);
% profile viewer;
% p = profile('info');
% profsave(p, 'profile_results');