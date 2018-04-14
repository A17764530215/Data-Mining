data = './data/';
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
DataSetIndices = 1 : 14;
ParamIndices = 2 : 11;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% ʵ�鿪ʼ
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [data, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ Stat, Time, CVStat ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'Stat', 'Time', 'CVStat');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);