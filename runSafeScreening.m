clear;clc;

% 加载数据集和网格搜索参数
load('DATA5R-Revision.mat');
load('LabSParams.mat');
Kernels = {'Linear', 'Poly' 'RBF'};
SParams = reshape(SParams, 20, 3);
% DATA5R
DataSetIndices = [ 20 ];
ParamIndices = [ 5,6,19,20 ];
OverWrite = false;

%% 实验开始trust-region-reflective 'TolCon', 300*eps, 
solver = optimoptions('QUADPROG', 'Display', 'off',...
    'Algorithm', 'interior-point-convex',...
    'MaxIter', 2000,...
    'OptimalityTolerance', 1e-12,...
    'ConstraintTolerance', 1e-12);
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
Path = './data/ssr-revision';
Kfold = 1;
%
for k = [ 1, 3  ]
    fprintf('runGridSearch:%s\n', Kernels{k});
    for i = DataSetIndices
        DataSet = DataSets(i);
        for j = ParamIndices
            Method = SParams{j,k};
            Name = [Method.ID, '-', DataSet.Name];
            fprintf('Experiments: %s\n', Name);
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
                    if mod(j, 2) == 0 && j > 6 && j < 19
                        [ Result, State ] = CompareAB(SavePath, DataSet, SParams{j-1,k}, SParams{j,k});
                        if State(1) == 1
                            if State(8) > 0.1
                                fprintf('pass: %s %.6f %.2f\n', Name, State(7), State(8));
                                fprintf(fd, 'pass: %s %.6f %.2f\n', Name, State(7), State(8));
                            else
                                fprintf('warning: %s %.6f %.2f\n', Name, State(7), State(8));
                                fprintf(fd, 'warning: %s %.6f %.2f\n', Name, State(7), State(8));
                            end
                        else
                            fprintf('error: %s %.2f %.6f %.9f\n', Name, State(7), State(8), State(1));
                            fprintf(fd, 'error: %s %.2f %.6f %.9f\n', Name, State(7), State(8), State(1));
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