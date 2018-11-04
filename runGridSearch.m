clc
clear

Path = './data/classify/rbf/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

%% �������ݼ���������������
load('MTL_UCI5.mat');
load('LabCParams.mat');

DataSets = MTL_UCI5;
IParams = CParams;

% ���ݼ�
DataSetIndices = [ 1:29 ];
ParamIndices = [ 7:11 ];

%% ʵ������
opts = InitOptions('clf', 0, []);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

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
        Method = IParams{j};
        Name = [Method.Name, '-', DataSet.Name];
        StatPath = [StatDir, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'CVStat', 'CVTime');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                delete('check-point.mat');
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);