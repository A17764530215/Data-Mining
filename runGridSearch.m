%% 加载数据集和网格搜索参数
clc
clear

Path = './data/paper2';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

load('DATA5.mat');
load('LabCParams.mat');

% DataSets = MTL_UCI5;
CParams = reshape(CParams, 16, 3);

% 数据集
DataSetIndices = [ 1:9 28:54];
ParamIndices = [ 15 16 ];
ForceWrite = true;

%% 实验设置
solver = struct('Display', 'off');
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = CParams{j, 2};
        Name = [Method.ID, '-', DataSet.Name];
        SavePath = sprintf('%s/%s/%d-fold/', Path, Method.kernel.type, DataSet.Kfold);
        if exist(SavePath, 'dir') == 0
            mkdir(SavePath);
        end
        StatPath = [SavePath, Name, '.mat'];
        if exist(StatPath, 'file') == 2 && ForceWrite == false
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime ] = GridSearch(DataSet, Method, true, opts);
%                 [ CVStat, CVTime ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
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