function [ yTest, Time ] = MTL(xTrain, yTrain, xTest, opts)
%MTL �˴���ʾ�йش����ժҪ
% Multi-Task Learning
%   �˴���ʾ��ϸ˵��

%% Multi Task Flag
    persistent IsMTL;
    if isempty(IsMTL)
        IsMTL = struct(...
            'SVM', 0, 'PSVM', 0, 'LS_SVM', 0, 'SVR', 0, 'PSVR', 0, 'LS_SVR', 0,...
            'TWSVM', 0, 'LSTWSVM', 0, 'vTWSVM', 0, 'ITWSVM', 0,...
            'TWSVR', 0, 'TWSVR_Xu', 0, 'LSTWSVR_Xu', 0, 'LSTWSVR_Mei', 0, 'LSTWSVR_Huang', 0,...
            'MTPSVR', 1, 'MTPSVM', 1, 'MTLS_SVM', 1, 'MTLS_SVR', 1,...
            'MTL_aLS_SVM', 1, 'RMMTL', 1, 'MTOC_SVM', 1, 'DMTSVM', 1,...
            'MCTSVM', 1, 'MTLS_TWSVM', 1, 'MTvTWSVM', 1, 'MTvTWSVM2', 1, 'MTBSVM', 1, 'MTLS_TBSVM', 1, ...
            'MTL_TWSVR', 1, 'MTL_TWSVR_Xu', 1, 'MTLS_TWSVR', 1, 'MTLS_TWSVR_Xu', 1,...
            'VSTG_MTL', 1 ...
        );
    end
    
%% Parse opts
    Name = opts.Name;
    % ������
    if IsMTL.(Name) == 0
        BaseLearner = str2func(Name);
        Learner = @MTLearner;
    else
        Learner = str2func(Name);
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