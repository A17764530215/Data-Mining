load('LabUCIReg.mat');

% ���ݼ�
DataSetIndices = 1: 17;
TaskNum = 5;
Kfold = 3;

% ��������񽻲���֤
for i = DataSetIndices
    UCI(i) = MultiTask( UCI(i), TaskNum, Kfold );
end

save('LabMulti.mat', 'LabMulti');