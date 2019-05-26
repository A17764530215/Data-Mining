function [ GSStat, GSTime, GSRate ] = GridSearch(DataSet, IParams, cv, opts)
%GRIDSEARCH 此处显示有关此函数的摘要
% 网格搜索
%   此处显示详细说明

    % 单任务模型
    str = split('SVM,PSVM,LS_SVM,SVR,PSVR,LS_SVR,TWSVM,LSTWSVM,vTWSVM,ITWSVM,TWSVR,TWSVR_Xu,LSTWSVR_Xu,LSTWSVR_Mei,LSTWSVR_Huang', ',');
    ST_Map = containers.Map(str, ones(length(str),1));
    % 多任务模型
    str = split('RMTL,IRMTL,CRMTL,MTPSVR,MTPSVM,MTLS_SVM,MTLS_SVR,MTL_aLS_SVM,RMMTL,MTOC_SVM,DMTSVM,MCTSVM,MTLS_TWSVM,MTvTWSVM,MTvTWSVM2,MTBSVM,MTLS_TBSVM,MTL_TWSVR,MTL_TWSVR_Xu,MTLS_TWSVR,MTLS_TWSVR_Xu,VSTG_MTL', ',');
    MT_Map = containers.Map(str, ones(length(str),1));
    % 方法是否自带网格搜索
    str = split('SVM,PSVM,LS_SVM,TWSVM,vTWSVM,LSTWSVM,IRMTL,CRMTL,MTPSVM,MTLS_SVM,MTL_aLS_SVM,DMTSVM,MCTSVM,MTLS_TWSVM,MTvTWSVM,MTvTWSVM2', ',');
    GS_Map = containers.Map(str, ones(length(str),1));
    % 方法是否自带安全筛选
    str = split('SSR_RMTL,SSR_IRMTL,SSR_CRMTL,SSR_DMTSVM,SSR_DMTSVMA', ',');
    SSR_Map = containers.Map(str, ones(length(str),1));
    
    keys = SSR_Map.keys;
    for k = 1 : length(keys)
        GS_Map(keys{k}) = 1;
        MT_Map(keys{k}) = 1;
    end
    
    % 获取全部数据并标准化
    [ X, Y, ValInd, TaskNum, Kfold ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    IParams.solver = opts.solver;
    
    if cv
        % 有交叉验证
        fprintf('crossvalid\n');
        [ GSStat, GSTime, GSRate ] = CrossValid(X, Y, TaskNum, Kfold, ValInd, IParams, opts);
    else
        % 无交叉验证
        fprintf('no crossvalid\n');
        [ GSStat, GSTime, GSRate ] = GS_Learner(X, Y, TaskNum, 1, ValInd, IParams, opts);
    end
    
    function [ GSStat, GSTime, GSRate ] = CrossValid(X, Y, TaskNum, Kfold, ValInd, IParams, opts)
        % 加载检查点
        if isfile('check-point.mat')
            load('check-point.mat', 'CVStat', 'CVTime', 'CVRate', 'fold');
            fprintf('GridSearch: load check-point, start at %d\n', fold);
            start = fold;
        else
            % 初始化变量
            n = GetParamsCount(IParams);
            CVStat = zeros(Kfold, n, opts.IndexCount, TaskNum);% 折数，参数数目，指标个数
            CVTime = zeros(Kfold, n, 1);
            if SSR_Map.isKey(IParams.Name)
                CVRate = zeros(Kfold, n, 5);
            else
                CVRate = zeros(Kfold, n, 1);
            end
            start = 1;
        end
        % 交叉验证与网格搜索
        for fold = start : Kfold
            [ Stat, Time, Rate ] = GS_Learner(X, Y, TaskNum, fold, ValInd, IParams, opts);
            [ CVStat(fold,:,:,:) ] = Stat;
            [ CVTime(fold,:,:) ] = Time;
            [ CVRate(fold,:,:) ] = Rate;
            save('check-point.mat', 'CVStat', 'CVTime', 'CVRate', 'fold');
        end
        [ GSStat, GSTime, GSRate ] = BatchCVStat(CVStat, CVTime, CVRate);
        delete('check-point.mat');
    end
    
    function [ GSStat, GSTime, GSRate ] = GS_Learner(X, Y, TaskNum, fold, ValInd, IParams, opts)
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, fold, ValInd);
        Name = IParams.Name;
        if GS_Map.isKey(Name)
            if SSR_Map.isKey(Name)
                if MT_Map.isKey(Name)
                    [ GSStat, GSTime, GSRate ] = MT_SSR_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                end
            else
                if MT_Map.isKey(Name)
                    [ GSStat, GSTime ] = MT_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                elseif ST_Map.isKey(Name)
                    [ GSStat, GSTime ] = ST_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                end
                GSRate = zeros(size(GSStat, 1), 1);
            end
        end
    end

    function [ GSStat, GSTime ] = MT_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % 采用了网格搜索加速的多任务学习器
        Learner = str2func(IParams.Name);
        [ y, GSTime ] = Learner(xTrain, yTrain, xTest, IParams);     
        n = length(y);
        GSStat = zeros(n, opts.IndexCount, TaskNum);
        for i = 1 : n
            GSStat(i, :, :) = MTLStatistics(TaskNum, y{i}, yTest, opts);
        end
    end

    function [ GSStat, GSTime ] = ST_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % 采用了网格搜索加速的单任务学习器
        % 多任务网格搜索统计
        Learner = str2func(IParams.Name);
        n = GetParamsCount(IParams);
        GSStat = zeros(n, opts.IndexCount, TaskNum);
        GSTime = zeros(n, TaskNum);
        for t = 1 : TaskNum
            [ y, GSTime(:,t) ] = Learner(xTrain{t}, yTrain{t}, xTest{t}, IParams);
            for i = 1 : n
                GSStat(i,:,t) = opts.Statistics(y{i}, yTest{t});
            end
        end
        GSTime = sum(GSTime, 2);
    end

    function [ GSStat, GSTime, GSRate ] = MT_SSR_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % 采用了网格搜索加速的，带有安全筛选准则的学习器
        Learner = str2func(IParams.Name);
        [ GSStat, GSTime, GSRate ] = Learner( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts );
    end

    function [ GSStat, GSTime, GSRate ] = BatchCVStat(CVStat, CVTime, CVRate)
        GSStat = cat(3, mean(CVStat, 1), std(CVStat, 1));
        GSTime = cat(3, mean(CVTime, 1), std(CVTime, 1));
        GSRate = cat(3, mean(CVRate, 1), std(CVRate, 1));
        GSStat = permute(GSStat, [2 3 4 1]);
        GSRate = permute(GSRate, [2,3,1]);
        GSTime = permute(GSTime, [2,3,1]);
    end

end