function [ CVStat, CVTime, CVRate ] = GridSearch(DataSet, IParams, cv, opts)
%GRIDSEARCH �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��

    % ������ģ��
    str1 = split('SVM,PSVM,LS_SVM,SVR,PSVR,LS_SVR,TWSVM,LSTWSVM,vTWSVM,ITWSVM,TWSVR,TWSVR_Xu,LSTWSVR_Xu,LSTWSVR_Mei,LSTWSVR_Huang', ',');
    ST_Map = containers.Map(str1, ones(length(str1),1));
    % ������ģ��
    str2 = split('RMTL,IRMTL,CRMTL,MTPSVR,MTPSVM,MTLS_SVM,MTLS_SVR,MTL_aLS_SVM,RMMTL,MTOC_SVM,DMTSVM,MCTSVM,MTLS_TWSVM,MTvTWSVM,MTvTWSVM2,MTBSVM,MTLS_TBSVM,MTL_TWSVR,MTL_TWSVR_Xu,MTLS_TWSVR,MTLS_TWSVR_Xu,VSTG_MTL', ',');
    MT_Map = containers.Map(str2, ones(length(str2),1));
    % �����Ƿ��Դ���������
    str = split('SVM,PSVM,LS_SVM,CRMTL,MTPSVM,MTLS_SVM,MTL_aLS_SVM,DMTSVM,MCTSVM,MTvTWSVM,MTvTWSVM2', ',');
    GS_Map = containers.Map(str, ones(length(str),1));
    % �����Ƿ��Դ���ȫɸѡ
    str = split('SSR_RMTL,SSR_IRMTL,SSR_CRMTL,SSR_DMTSVM,SSR_DMTSVMA', ',');
    SSR_Map = containers.Map(str, ones(length(str),1));
    
    keys = SSR_Map.keys;
    for i = 1 : length(keys)
        GS_Map(keys{i}) = 1;
        MT_Map(keys{i}) = 1;
    end
    
    % ��ȡȫ�����ݲ���׼��
    [ X, Y, ValInd, TaskNum, Kfold ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    IParams.solver = opts.solver;
    
    if cv
        % �н�����֤
        fprintf('crossvalid\n');
        [ CVStat, CVTime, CVRate ] = CrossValid(X, Y, TaskNum, Kfold, ValInd, IParams, opts);
    else
        % �޽�����֤
        fprintf('no crossvalid\n');
        [ CVStat, CVTime, CVRate ] = GS_Learner(X, Y, TaskNum, 1, ValInd, IParams, opts);
    end
    
    function [ CVStat, CVTime, CVRate ] = CrossValid(X, Y, TaskNum, Kfold, ValInd, IParams, opts)
        % ���ؼ���
        if isfile('check-point.mat')
            load('check-point.mat', 'CVStat', 'CVTime', 'CVRate', 'fold');
            fprintf('GridSearch: load check-point, start at %d\n', fold);
            start = fold;
        else
            % ��ʼ������
            n = GetParamsCount(IParams);
            CVStat = zeros(Kfold, n, opts.IndexCount, TaskNum);% ������������Ŀ��ָ�����
            if SSR_Map.isKey(IParams.Name)
                CVTime = zeros(Kfold, n, 2);
                CVRate = zeros(Kfold, n, 4);
            else
                CVTime = zeros(Kfold, n, 1);
                CVRate = zeros(Kfold, n, 1);
            end
            start = 1;
        end
        % ������֤����������
        for fold = start : Kfold
            fprintf('CrossValid: %d\n',  fold);
            [ Stat, Time, Rate ] = GS_Learner(X, Y, TaskNum, fold, ValInd, IParams, opts);
            [ CVStat(fold,:,:,:) ] = Stat;
            [ CVTime(fold,:,:) ] = Time;
            [ CVRate(fold,:,:) ] = Rate;
            save('check-point.mat', 'CVStat', 'CVTime', 'CVRate', 'fold');
        end
        [ CVStat, CVTime ] = BatchCVStat(CVStat, CVTime);
        delete('check-point.mat');
    end
    
    function [ Stat, Time, Rate ] = GS_Learner(X, Y, TaskNum, fold, ValInd, IParams, opts)
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, fold, ValInd);
        Name = IParams.Name;
        if GS_Map.isKey(Name)
            if SSR_Map.isKey(Name)
                if MT_Map.isKey(Name)
                    [ Stat, Time, Rate ] = MT_SSR_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                end
            else
                if MT_Map.isKey(Name)
                    [ Stat, Time ] = MT_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                elseif ST_Map.isKey(Name)
                    [ Stat, Time ] = ST_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts);
                end
                Rate = zeros(size(Stat, 1), 1);
            end
        end
    end

    function [ Stat, Time ] = MT_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % �����������������ٵĶ�����ѧϰ��
        Learner = str2func(IParams.Name);
        [ y, Time ] = Learner(xTrain, yTrain, xTest, IParams);     
        n = length(y);
        Stat = zeros(n, opts.IndexCount, TaskNum);
        for i = 1 : n
            Stat(i, :, :) = MTLStatistics(TaskNum, y{i}, yTest, opts);
        end
    end

    function [ Stat, Time ] = ST_GS_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % �����������������ٵĵ�����ѧϰ��
        % ��������������ͳ��
        Learner = str2func(IParams.Name);
        n = GetParamsCount(IParams);
        Stat = zeros(n, opts.IndexCount, TaskNum);
        Time = zeros(n, TaskNum);
        for t = 1 : TaskNum
            [ y, Time(:,t) ] = Learner(xTrain{t}, yTrain{t}, xTest{t}, IParams);
            for i = 1 : n
                Stat(i,:,t) = opts.Statistics(y{i}, yTest{t});
            end
        end
        Time = sum(Time, 2);
    end

    function [ Stat, Time, Rate ] = MT_SSR_Learner(xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts)
    % �����������������ٵģ����а�ȫɸѡ׼���ѧϰ��
        Learner = str2func(IParams.Name);
        [ Stat, Time, Rate ] = Learner( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts );
    end

    function [ CVStat, CVTime ] = BatchCVStat(GSStat, GSTime)
        CVStat = cat(3, mean(GSStat, 1), std(GSStat, 1));
        CVTime = cat(1, mean(GSTime, 1), std(GSTime, 1));
        CVStat = permute(CVStat, [2 3 4 1]);
        CVTime = permute(CVTime, [2,1]);
    end

end