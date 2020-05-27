function [ OStat, TStat ] = CrossValid( Learner, X, Y, TaskNum, Kfold, ValInd, Params, opts )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% �����񽻲���֤
%   �˴���ʾ��ϸ˵��

    CVStat = zeros(Kfold, opts.IndexCount, TaskNum);
    CVTime = zeros(Kfold, 1);
    for j = 1 : Kfold
        fprintf('CrossValid: %d\n', j);
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
        [ y, Time ] = Learner(xTrain, yTrain, xTest, Params);
        CVStat(j,:,:) = MTLStatistics(TaskNum, y, yTest, opts);
        CVTime(j,:) = Time;
    end
    
    [OStat, TStat] = CVStatistics(CVStat, CVTime);
end
