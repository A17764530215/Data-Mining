clc
clear

Path = './data/ssr';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('DATA5.mat');
load('LabSParams.mat');

% 数据集
DataSetIndices = [ 1:57 ];
ParamIndices = [ 1:2 5:6 ];
ForceWrite = false;

%% 实验设置 RMTL
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
        Method = SParams{j};
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
IParams = CreateParams(Method);