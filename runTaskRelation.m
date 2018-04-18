data = './data/';
images = './images/';
weights = './weights/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabReg.mat');
load('LabIParams.mat');

% ���ݼ�
DataSetIndices = [1:14];
ParamIndices = [9 11];
BestParams = 1024;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% ʵ�鿪ʼ
fprintf('runTaskRelation\n');
for i = DataSetIndices
    DataSet = LabReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [ DataSet.Name, '-', Method.Name, '-W' ];
        try
            % ������ѧϰ
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, DataSet.TaskNum, 1, ValInd);
            [~, ~, W] = MTL(xTrain, yTrain, xTest, Params);
            % ��������ԶԱ�
            imshow(TaskRelation(W), 'InitialMagnification', 'fit');
            save([ weights, Name ], 'W');
            saveas(gcf, [ images , Name ], 'png');
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end