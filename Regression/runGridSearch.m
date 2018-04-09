images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');
load('Outputs.mat', 'Outputs');
% ���ݼ�
DataSetIndices = [3];
ParamIndices = [4 5];
% ʵ������
TaskNum = 8;
Kfold = 3;
solver = []; % optimoptions('fmincon', 'Display', 'off');

% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % ������������ݼ�
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    [X, Y] = Normalize(X, Y);
    % ������֤����
    opts = struct('solver', solver);
    % ��ÿһ���㷨
    for j = ParamIndices
        % ����������������֤
        [ Stat, CVStat ] = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % ������������������֤�Ľ��
        Output = {DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat};
        Outputs{i, j} = Output;
        save('Outputs.mat', 'Outputs');
        save([DataSet.Name, '-Stat.mat'], 'Stat');
        save([DataSet.Name, '-CVStat.mat'], 'CVStat');
    end
end

save('Outputs.mat', 'Outputs');