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
    Output = zeros(nParams, 4);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        Params = IParams(i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', j);
            test = (ValInd == j);
            train = ~test;
            MTL_TrainTest
%             [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
%             [ Stat ]  = Wrapper(Learner, TaskNum, X(train,:), Y(train,:), xTest, yTest, Params);
        end
    end
    
%% Statistics
    function [ XT, YT ] = MTL_TrainTest(X, Y, TaskNum, ValInd, Kfold)
        XT = cell(TaskNum, 1);
        YT = cell(TaskNum, 1);
        for ii = 1 : TaskNum
            Xt = X{t};
            Yt = Y{t};
            Vt = ValInd{t};
            XT{ii} = Xt(Vt==Kfold);
            YT{ii} = Yt(Vt==Kfold);
        end
    end

    function [ Stat ]  = Wrapper(Learner, TaskNum, xTrain, yTrain, xTest, yTest, Params)
        Stats = {@mae, @mse, @sae, @sse}
        [ y, Time ] = Learner(xTrain, yTrain, xTest, Params);
        Stat = zeros(TaskNum, 4);
        for ii = 1 : TaskNum
            for jj = 1 : 4
                Func = Stats{jj};
                Stat(ii, jj) = Func(y{i}-yTest{i}, y{i}, yTest{i});
            end
        end
    end
end