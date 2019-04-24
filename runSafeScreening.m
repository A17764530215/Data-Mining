clear;clc;

% 加载数据集和网格搜索参数
load('DATA5R.mat');
load('LabSParams.mat');
Kernels = {'Linear', 'Poly' 'RBF'};
SParams = reshape(SParams, 12, 3);
% DATA5R
DataSetIndices = [ 1:31 ];
ParamIndices = [ 7:8 ];
OverWrite = false;

%% 实验开始
solver = struct('Display', 'off');
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
Path = './data/ssr';
Kfold = 1;

for k = [ 1 3 ]
    fprintf('runGridSearch:%s\n', Kernels{k});
    for i = DataSetIndices
        DataSet = DataSets(i);
        fprintf('DataSet: %s\n', DataSet.Name);
        [ X, Y, ValInd ] = GetMultiTask(DataSet);
        [ X ] = Normalize(X);
        for j = ParamIndices
            Method = SParams{j,k};
            Name = [Method.ID, '-', DataSet.Name];
            SavePath = sprintf('%s/%s/%d-fold/', Path, Method.kernel.type, DataSet.Kfold);
            if exist(SavePath, 'dir') == 0
                mkdir(SavePath);
            end
            StatPath = [SavePath, Name, '.mat'];
            if exist(StatPath, 'file') == 2 && OverWrite == false
                fprintf(fd, 'skip: %s\n', StatPath);
                continue;
            else
                try
                    [ CVStat, CVTime, CVRate ] = SSR(X, Y, Method, DataSet.TaskNum, Kfold, ValInd, opts );
                    save(StatPath, 'CVStat', 'CVTime', 'CVRate');
                    fprintf(fd, 'save: %s\n', StatPath);
                    if strcmp(Method.Name, 'SSR_CRMTL')
                        [ Result, State ] = CompareAB(SavePath, DataSet, SParams{j-1,k}, SParams{j,k});
                        if State(1) == 1 && State(7) > 0.1
                            fprintf('pass: %s %.2f %.2f\n', Name, State(6), State(7));
                            fprintf(fd, 'pass: %s %.2f %.2f\n', Name, State(6), State(7));
                        else
                            fprintf('error: %s %.2f %.2f\n', Name, State(6), State(7));
                            fprintf(fd, 'error: %s %.2f %.2f\n', Name, State(6), State(7));
                            break;
                        end
                    end
                catch Exception
                    delete('check-point.mat');
                    fprintf(fd, 'Exception in %s\n', Name);
                end
            end
        end
    end
end
fclose(fd);
IParams = CreateParams(Method);