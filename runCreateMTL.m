addpath(genpath('./datasets'));
addpath(genpath('./utils'));

% load('LabReg.mat');

% ���ݼ�
DataSetIndices = 18;
TaskNum = 2;
Kfold = 5;

% ��������񽻲���֤
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
end

% �������ݼ������С
[m, ~] = size(LabReg);
Size = zeros(m, 1);
for i = 1 : m
    [ m, n ] = size(LabReg(i).Data);
    TaskNum = LabReg(i).TaskNum;
    Kfold = LabReg(i).Kfold;
    Size(i,:) = m*n*TaskNum*Kfold;
end

% �������С����
[ ~, IDX ] = sort(Size);
LabReg = LabReg(IDX);
save('./datasets/LabReg.mat', 'LabReg');