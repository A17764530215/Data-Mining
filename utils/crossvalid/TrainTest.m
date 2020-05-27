function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, Kfold, ValInd)
%TRAINTEST �˴���ʾ�йش˺�����ժҪ
% ѵ�����Լ�
%   �˴���ʾ��ϸ˵��

    test = ValInd==Kfold;
    train = ~test;
    xTrain = X(train,:);
    yTrain = Y(train,:);
    xTest = X(test,:);
    yTest = Y(test,:);
end