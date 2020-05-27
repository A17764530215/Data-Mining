function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, Kfold, ValInd)
%MTLTRAINTEST �˴���ʾ�йش˺�����ժҪ
% ������ѵ�����Լ�
%   �˴���ʾ��ϸ˵��

    xTrain = cell(TaskNum, 1);
    yTrain = cell(TaskNum, 1);
    xTest = cell(TaskNum, 1);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, Kfold, ValInd{t});
    end
end
