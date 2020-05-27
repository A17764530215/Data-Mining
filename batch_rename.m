clc
clear

%% 加载数据集和网格搜索参数
load('MTL_UCI.mat');
load('LabCParams.mat');

DataSets = MTL_UCI;
IParams = CParams;

% 数据集
DataSetIndices = [1:64];
ParamIndices = [ 1:13 ];

%% 实验开始
fprintf('runGridSearch\n');
fd = fopen(['./log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    for j = ParamIndices
        Method = IParams{j};
        OldName = [DataSet.Name, '-', Method.Name, '.mat'];
        NewName = [Method.Name, '-', DataSet.Name, '.mat'];
        if exist(OldName, 'file') == 2
            fprintf(fd, 'rename: %s\n', OldName);
            command = ['rename' 32 OldName 32 NewName];
            status = dos(command);
            if status == 0
                disp([OldName, '已被重命名为 ', NewName])
            else
                disp([OldName, '重命名失败!'])
            end
        else
            fprintf(fd, 'skip: %s\n', OldName);
        end
    end
end
fclose(fd);

%%
fprintf('runGridSearch\n');
Method = struct('OldName', 'LS_TWSVM', 'NewName', 'LSTWSVM');
fd = fopen(['./log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    OldName = [Method.OldName, '-', DataSet.Name, '.mat'];
    NewName = [Method.NewName, '-', DataSet.Name, '.mat'];
    if exist(OldName, 'file') == 2
        fprintf(fd, 'rename: %s\n', OldName);
        command = ['rename' 32 OldName 32 NewName];
        status = dos(command);
        if status == 0
            disp([OldName, '已被重命名为 ', NewName])
        else
            disp([OldName, '重命名失败!'])
        end
    else
        fprintf(fd, 'skip: %s\n', OldName);
    end
end
%%
N = [ 128, 128, 128, 128, 128 ];
n = sum(N);
A = ones(n, 300);
tic
P = A*A';
Pc = mat2cell(P, N, N);
toc
%%.