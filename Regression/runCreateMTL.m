addpath(genpath('./datasets'));
addpath(genpath('./utils'));

% load('LabReg.mat');

% ���ݼ�
DataSetIndices = 1:5;
TaskNum = 2;
Kfold = 5;

% ��������񽻲���֤
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
end

save('./datasets/LabReg.mat', 'LabReg');