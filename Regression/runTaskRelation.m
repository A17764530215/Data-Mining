data = './data/';
images = './images/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMulti.mat');
load('LabIParams.mat');

% ���ݼ�
DataSetIndices = [4 8 11 14];
ParamIndices = [4];
BestParams = 1;

% ʵ������
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% ʵ�鿪ʼ
fprintf('runTaskRelation\n');
for i = DataSetIndices
    DataSet = LabMulti(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [ DataSet.Name, '-', Method.Name, '-W' ];
        StatPath = [ data , Name ];
        try
            % ������ѧϰ
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, DataSet.TaskNum, 1, ValInd);
            [~, ~, W] = MTL(xTrain, yTrain, xTest, Params);
            % ��������ԶԱ�
%             imshow(TaskRelation(W), 'InitialMagnification', 'fit');
%             imsave(gcf, StatPath, 'png');
            % save as mat
            save([StatPath, '.mat'], W);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end