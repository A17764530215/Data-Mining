addpath(genpath('./datasets'));
addpath(genpath('./utils'));

load('LabReg.mat');

% ���ݼ�
DataSetIndices = 1:5;
TaskNum = 2;
Kfold = 5;

% ��������񽻲���֤
Size = zeros(14, 1);
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
    % �������ݼ������С
    [ m, n ] = size(LabReg(i).Data);
    TaskNum = LabReg(i).TaskNum;
    Kfold = LabReg(i).Kfold;
    Size(i,:) = m*n*TaskNum*Kfold;
end

% �������С����
[ ~, IDX ] = sort(Size);
LabReg = LabReg(IDX);
save('./datasets/LabReg.mat', 'LabReg');