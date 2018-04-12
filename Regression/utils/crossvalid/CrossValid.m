function [ OStat ] = CrossValid( Learner, X, Y, TaskNum, Kfold, ValInd, Params )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% Cross Validation
%   �˴���ʾ��ϸ˵��

    % �����񽻲���֤ͳ��
    CVStat = zeros(Kfold, 4, TaskNum);
    % ������֤
    for j = 1 : Kfold
        fprintf('CrossValid: %d\n', j);
        % �ָ�ѵ�����Ͳ��Լ�
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
        % ��һ��������ѵ����Ԥ��
        [ y ] = Learner(xTrain, yTrain, xTest, Params);
        % ͳ�ƶ�����ѧϰ����
        CVStat(j,:,:) = MTLStatistics(TaskNum, y, yTest);
    end
    
    % ͳ�ƶ����񽻲���֤���
    OStat = CVStatistics(CVStat);

end
