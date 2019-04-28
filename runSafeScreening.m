clear;clc;

% 加载数据集和网格搜索参数
load('DATA5R.mat');
load('LabSParams.mat');
Kernels = {'Linear', 'Poly' 'RBF'};
SParams = reshape(SParams, 18, 3);
% DATA5R
DataSetIndices = [ 1:31 ];
ParamIndices = [ 14 16 18 ];
OverWrite = true;

%% 实验开始
solver = [];% optimoptions('fmincon', 'Display', 'notify', 'Algorithm', 'interior-point', 'TolCon', 1e-12, 'MaxIter', 2000);
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
Path = './data/ssr-safe_test';
Kfold = 1;

for k = [ 1 3 ]
    fprintf('runGridSearch:%s\n', Kernels{k});
    for i = DataSetIndices
        DataSet = DataSets(i);
        fprintf('DataSet: %s\n', DataSet.Name);
%         [ X, Y, ValInd ] = GetMultiTask(DataSet);
%         [ X ] = Normalize(X);
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
                    [ CVStat, CVTime, CVRate ] = GridSearch(DataSet, Method, false, opts);
                    % 保存记录
                    save(StatPath, 'CVStat', 'CVTime', 'CVRate', 'Method');
                    fprintf(fd, 'save: %s\n', StatPath);
                    if strfind(Method.Name, 'SSR_')
                        [ Result, State ] = CompareAB(SavePath, DataSet, SParams{j-1,k}, SParams{j,k});
                        if State(1) == 1
                            if State(7) > 0.1
                                fprintf('pass: %s %.2f %.2f\n', Name, State(6), State(7));
                                fprintf(fd, 'pass: %s %.2f %.2f\n', Name, State(6), State(7));
                            else
                                fprintf('warning: %s %.2f %.2f\n', Name, State(6), State(7));
                                fprintf(fd, 'warning: %s %.2f %.2f\n', Name, State(6), State(7));
                            end
                        else
                            fprintf('error: %s %.2f %.2f %.9f\n', Name, State(6), State(7), State(1));
                            fprintf(fd, 'error: %s %.2f %.2f %.9f\n', Name, State(6), State(7), State(1));
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