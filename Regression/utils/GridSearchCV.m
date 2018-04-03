function [ Output ] = GridSearchCV( Learner, X, Y, IParams, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ���������������������֤
%   �˴���ʾ��ϸ˵��
% ������
%    Learner    -ѧϰ��
%          X    -����
%          Y    -��ǩ
%     Params    -��������
%      Kfold    -K�۽�����֤
% �����
%     Output    -����������������֤���

    TaskNum = opts.TaskNum;
    Kfold = opts.Kfold;
    ValInd = opts.ValInd;

    nParams = length(IParams);
    Output = zeros(nParams, 5);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        TaskStat = zeros(Kfold, 4, TaskNum);
        Params = IParams(i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', kj);
            % �ָ�ѵ�����Ͳ��Լ�
            [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
            % ��һ��������ѵ����Ԥ��
            [ y, ~ ] = Learner(xTrain, yTrain, xTest, Params);
            % ͳ�ƶ�����ѧϰ����
            TaskStat(j,:,:) = Statistics(y, yTest, TaskNum);
        end
        Output(i,:) = MTLStatistics(TaskStat);
    end
    
%% Statistics
    function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, ValInd, Kfold)
        test = ValInd==Kfold;
        train = ~test;
        xTrain = X(train,:);
        yTrain = Y(train,:);
        xTest = X(test,:);
        yTest = Y(test,:);
    end

    function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, ValInd, Kfold)
        xTrain = cell(TaskNum, 1);
        yTrain = cell(TaskNum, 1);
        xTest = cell(TaskNum, 1);
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, ValInd{t}, Kfold);
        end
    end

    function [ TaskStat ]  = Statistics(y, yTest, TaskNum)
        % ͳ��ָ��
        Funcs = {@mae, @mse, @sae, @sse};
        TaskStat = zeros(TaskNum, 4);
        for t = 1 : TaskNum
            for k = 1 : 4
                Func = Funcs{k};
                TaskStat(k, t) = Func(y{t}-yTest{t}, y{t}, yTest{t});
            end
        end
    end

    function [ OStat ] = MTLStatistics(TaskStat, TaskNum)
        % ������ͳ��ָ��
        OStat = cell(TaskNum, 4);
        for t = 1 : TaskNum
            ITask = TaskStat(:,:,TaskNum);
            % �õ�K��ƽ��ֵ
            OStat(t, :) = mean(ITask, 1);
        end
    end
end