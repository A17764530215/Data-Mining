Path = './data/regression/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLTest.mat');
load('LabRParams.mat');
DataSets = LabMTLTest;
IParams = RParams;

% ���ݼ�
DataSetIndices = [1:3];
ParamIndices = [1 3 5 7 9 13];

% ʵ������
solver = [];
opts = struct('solver', solver, 'Statistics', @ClfStat, 'IndexCount', 1);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% ʵ�鿪ʼ
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [Path, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'CVStat', 'CVTime');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);