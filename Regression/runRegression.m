images = './images/';
data = './data/';
% �������·��
addpath(genpath('./model'));
addpath(genpath('./utils'));
% �������ݼ���������������
load('LabUCIReg.mat');
load('LabParams.mat');
% ���ݼ�
DataSetIndices = [3 4];
ParamIndices = [4 5];
CVIndices = [1 4 9];
% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
% ʵ�鿪ʼ
fprintf('runRegression\n');
DataSet = LabUCIReg(3);
for i = ParamIndices
    TParams = IParams{3, 1};
    % ��ÿһ��MTL����
    for j = [ 2 3 4 ]
        % ������ѧϰ
        Params = {i, 1};
        Params.solver = solver;
        Stat(i,:,:) = CrossValid( @MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params );
    end
end