addpath('./utils/');
load('LabSVMReg.mat');

% ���ݼ�
DataSetIndices = 1: 5;
TaskNum = 5;
Kfold = 3;

% ��������񽻲���֤
for i = DataSetIndices
    LabSVMReg(i) = MultiTask( LabSVMReg(i), TaskNum, Kfold );
end

save('LabSVMReg.mat', 'LabSVMReg');