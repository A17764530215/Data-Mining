load('LabUCIReg.mat');

% ���ݼ�
DataSetIndices = [1 2 3 4 5];
TaskNum = 5;
Kfold = 3;

% ��������񽻲���֤
for i = DataSetIndices
    LabUCIReg(i) = MultiTask( LabUCIReg(i), TaskNum, Kfold );
end

save('LabUCIReg.mat', 'LabUCIReg');