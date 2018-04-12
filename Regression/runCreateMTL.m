addpath('./utils/');
addpath('./datasets/');

load('LabMulti.mat');

% ���ݼ�
DataSetIndices = 9 : 11;
TaskNum = 4;
Kfold = 3;

% ��������񽻲���֤
for i = DataSetIndices
    LabMulti(i) = MultiTask( LabMulti(i), TaskNum, Kfold );
end

save('./datasets/LabMulti.mat', 'LabMulti');