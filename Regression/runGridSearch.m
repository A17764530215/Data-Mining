images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% ʵ�������ݼ�
DataSetIndices = [3 4];
ParamIndices = [1];
% ������
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, 8);

% ����Ϊ������ѧϰ��
Learner = @MTL;

% ������ͼģʽ
fprintf('runGridSearch\n');
% ��ÿһ�����ݼ�
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
%     [X, Y] = SplitDataLabel(DataSet.Data);
    % ������������ݼ�
    [X, Y] = MultiTask(DataSet, 4);
    % ������֤����
    ValInd = CrossValInd( DataSet.Instances, Kfold );
    % ��ÿһ��ʵ�����
    for j = 1 : nP
        % ѡ��ʵ�����
        Params = IParams{j};
        % ����������������֤
        Outputs = GridSearchCV(Learner, X, Y, ValInd, Params, Kfold);
        % ������������������֤�Ľ��
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, Output
        };
    end
end

% save('runGridSearch.mat', Output);