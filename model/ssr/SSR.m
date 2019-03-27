function [ CVStat, CVTime, CVRate ] = SSR(X, Y, Method, TaskNum, Kfold, ValInd, opts )
%SAFE_SCREENING_RULES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
%% Safe screening flag
    persistent IsSSR;
    if isempty(IsSSR)
        IsSSR = struct('SSR_RMTL', 1, 'SSRC_IRMTL', 1, 'SSRM_IRMTL', 1, 'SSRP_IRMTL', 1);
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
        CVStat = zeros(n, opts.IndexCount, TaskNum);
        CVTime = zeros(n, 2);
        CVRate = zeros(n, 1);
        % ����������֤����������
        for i = 1 : n
            Params = GetParams(Method, i);
            Params.solver = solver;
            [ y, Time ] = MTL(xTrain, yTrain, xTest, Params);
            CVStat(i,:,:) = MTLStatistics(TaskNum, y, yTest, opts);
            CVTime(i,:) = Time;
        end
    end
end