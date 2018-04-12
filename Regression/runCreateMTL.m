addpath('./utils/');
addpath('./datasets/');

load('LabReg.mat');

% ���ݼ�
DataSetIndices = 13;
TaskNum = 20;
Kfold = 3;

% ��������񽻲���֤
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
end

save('./datasets/LabReg.mat', 'LabReg');