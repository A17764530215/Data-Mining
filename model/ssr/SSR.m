function [ CVStat, CVTime, CVRate ] = SSR(X, Y, Method, TaskNum, Kfold, ValInd, opts )
%SAFE_SCREENING_RULES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
%% Safe screening flag
    persistent IsSSR;
    if isempty(IsSSR)
        IsSSR = struct('SSR_RMTL', 1);
    end
    
%% Parse opts
    Name = Method.Name;
    % Safe screening
    if isfield(IsSSR, Name)
        Learner = str2func(Name);
    else
        Learner = @GridSearch;
    end
    
    [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, Kfold, ValInd);
    [ CVStat, CVTime, CVRate ] = Learner( xTrain, yTrain, xTest, yTest, TaskNum, Method, opts );
    
%% No safe screening
    function [ CVStat, CVTime, CVRate ] = GridSearch( xTrain, yTrain, xTest, yTest, TaskNum, Method, opts)
        solver = opts.solver;
        n = GetParamsCount(Method);
        CVStat = zeros(n, 2*opts.IndexCount, TaskNum);
        CVTime = zeros(n, 2);
        CVRate = zeros(n, 1);
        % ����������֤����������
        for i = 1 : n
            Params = GetParams(Method, i);
            Params.solver = solver;
            BaseLearner = str2func(Name);
            [ y, Time ] = BaseLearner(xTrain, yTrain, xTest, Params);
            Stat = MTLStatistics(TaskNum, y, yTest, opts);
            CVStat(i,:,:) = [ Stat; zeros(size(Stat)) ];
            CVTime(i,:) = Time;
        end
    end
end