images = './images/';
data = './data/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat');
load('LabParams.mat');
% ���ݼ�
DataSetIndices = [3 4];
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
        % �õ��㷨��Ϣ
        Method = OParams{j};
        % ����������������֤
        [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % ������������������֤�Ľ��
        Output = {DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat};
        save('Outputs.mat', 'Outputs');
        save([data, DataSet.Name, '-', Method.Name, '.mat'], 'Stat', 'CVStat');
    end
end