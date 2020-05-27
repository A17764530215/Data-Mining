clc
clear

%% �������ݼ���������������
load('MTL_UCI.mat');
load('LabCParams.mat');

DataSets = MTL_UCI;
IParams = CParams;

% ���ݼ�
DataSetIndices = [1:64];
ParamIndices = [ 1:13 ];

%% ʵ�鿪ʼ
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
                disp([OldName, '�ѱ�������Ϊ ', NewName])
            else
                disp([OldName, '������ʧ��!'])
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
            disp([OldName, '�ѱ�������Ϊ ', NewName])
        else
            disp([OldName, '������ʧ��!'])
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