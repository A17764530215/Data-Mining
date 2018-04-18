function [ yTest, Time ] = MultiClf(xTrain, yTrain, xTest, opts)
%MULTICLF �˴���ʾ�йش����ժҪ
% Multi-Classifier
%   �˴���ʾ��ϸ˵��

%% Parse opts
    Classes = opts.Classes;     % ������
    Labels = opts.Labels;       % ��ʵ��ǩ
    Params = opts.Params;       % ѧϰ������ 
    
    %% ��ѧϰ��
    try
       BaseLearner = str2func(Params.Name);
    catch Exception
        throw(MException('MultiClf', 'unresolved function:%s', Params.Name));
    end
    
    %% ѵ��ģʽ
    Mode = opts.Mode;           % ģʽ��OvO, OvR
    switch (Mode)
        case {'OvO'}
            Learner = @MultiOvO;
        case {'OvR'}
            Learner = @MultiOvR;
        otherwise
            throw(MException('MultiClf', [ 'Mode "', Node, '" undefined']));
    end
    
    %% ��ʼѧϰ
    [ yTest, Time ] = Learner(BaseLearner, xTrain, yTrain, xTest, Params);

%% Multi-OvO
function [ yTest, Time ] = MultiOvO(Learner, xTrain, yTrain, xTest, opts)
    tic;
    
    [m, ~] = size(xTest);
    YTests = zeros(m, m*(m+1)/2);

    nIndex = 0;
    for i = 1 : Classes - 1
        for j = i + 1 : Classes
            nIndex = nIndex + 1;
            [ XTrain, YTrain ] = OvO(xTrain, yTrain, Labels, i, j);
            [ YTest, ~ ] = Learner(XTrain, YTrain, xTest, opts);
            YTest(YTest==1) = i;
            YTest(YTest==-1) = j;
            YTests(:, nIndex) = YTest;
        end
    end

    Time = toc;
    
    yTest = zeros(m, 1);
    yVote = zeros(1, Classes);
    for i = 1 : m
        for j = 1 : Classes
            yVote(1, j) = sum(YTests(i, :) == j);
        end
        [~, IDX] = sort(yVote(1, :), 'descend');
        yTest(i) = Labels(IDX(1));
    end
end

%% Multi-OvR
function [ yTest, Time ] = MultiOvR(Learner, xTrain, yTrain, xTest, opts)
    tic;
    % �����
    yTest = zeros(m, 1);
    for i = 1 : Classes
        % OvR�ָ����ݼ�
        [ XTrain, YTrain ] = OvR(xTrain, yTrain, Labels, i);
        % ѵ����Ԥ��
        [ YTest, ~ ] = Learner(XTrain, YTrain, xTest, opts);
        % ������㸳ֵ
        yTest(YTest==1) = Labels(i);
    end
    Time = toc;
end

%% One vs One
    function [ Xr, Yr ] = OvO( X, Y, Lables, i, j )
        %OvO �˴���ʾ�йش˺�����ժҪ
        % i��Ϊ����㣬j�����
        %   �˴���ʾ��ϸ˵��

        Ip = Y==Lables(i);
        In = Y==Lables(j);
        Xp = X(Ip, :);
        Yp = ones(length(Xp), 1);
        Xn = X(In, :);
        Yn = -ones(length(Xn), 1);
        Xr = [Xp; Xn];
        Yr = [Yp; Yn];
    end

%% One vs Rest
    function [ Xr, Yr ] = OvR( X, Y, Lables, i)
        %OvO �˴���ʾ�йش˺�����ժҪ
        % i��Ϊ����㣬���ฺ���
        %   �˴���ʾ��ϸ˵��
        
        Ip = Y==Lables(i);
        In = Y~=Lables(i);
        Xp = X(Ip, :);
        Yp = ones(length(Xp), 1);
        Xn = X(In, :);
        Yn = -ones(length(Xn), 1);
        Xr = [Xp; Xn];
        Yr = [Yp; Yn];
    end

end