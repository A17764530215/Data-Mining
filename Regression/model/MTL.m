function [ yTest, Time ] = MTL(xTrain, yTrain, xTest, opts)
%MTL �˴���ʾ�йش����ժҪ
% Multi-Task Learning
%   �˴���ʾ��ϸ˵��

    Names = { 'SVR', 'PSVR', 'TWSVR', 'MTL_PSVR', 'MTL_TWSVR' };
    Learners = { @SVR, @PSVR, @TWSVR, @MTL_PSVR, @MTL_TWSVR };
    IsMTL = [ 0 0 0 1 1 ];
    
%% Parse opts
    N = length(Learners);
    for i = 1 : N
        if strcmp(Names{i}, opts.Name)
            if IsMTL(i)
                % ����ѧϰ��
                Learner = Learners{i};
            else
                % ���ö������ѧϰ��
                BaseLearner = Learners{i};
                Learner = @MTLearner;
            end
        end
    end
    
    [ yTest, Time ] = Learner(xTrain, yTrain, xTest, opts);

%% Multi-Task Learner
    function [ yTest, Time ] = MTLearner(xTrain, yTrain, xTest, opts)
        [ TaskNum, ~ ] = size(xTrain);
        yTest = cell(TaskNum, 1);
        Times = zeros(TaskNum, 1);
        % ʹ��ͬ����ѧϰ��ѵ��Ԥ��ÿһ������
        for t = 1 : TaskNum
            [ y, time ] = BaseLearner(xTrain{t}, yTrain{t}, xTest{t}, opts);
            yTest{t} = y;
            Times(t) = time;
        end
        Time = sum(Times);
    end
    
end