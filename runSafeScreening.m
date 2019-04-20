clc
clear

% �������ݼ���������������
load('DATA5R.mat');
load('LabSParams.mat');
SParams = reshape(SParams, 28, 3);
% DATA5R
DataSetIndices = [ 1:19 ];
ParamIndices = [ 19 20 ];
OverWrite = false;

%% ʵ������ RMTL
solver = struct('Display', 'off');
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
Path = './data/ssr';
Kfold = 1;
% ʵ�鿪ʼ
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for k = [ 1 3 ]
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