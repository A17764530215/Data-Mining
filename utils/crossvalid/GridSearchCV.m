function [ CVStat, CVTime ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ���������������������֤
%   �˴���ʾ��ϸ˵��

    % ��ʼ������
    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 2*opts.IndexCount, TaskNum);
    CVTime = zeros(nParams, 2);
    % ���ؼ���
    if isfile('check-point.mat')
        load('check-point.mat', 'CVStat', 'CVTime', 'Index');
        start = Index;
        fprintf('GridSearchCV: load check-point, start at %d\n', start);
    else
        start = 1;
    end
    % ��ʼ��������
    fprintf('GridSearchCV: %d Params\n', nParams);
    for i = start : nParams
        fprintf('GridSearchCV: %d\n', i);
        Params = GetParams(IParams, i);
        Params.solver = solver;
        [CVStat(i,:,:), CVTime(i,:)]= CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params, opts);
        if mod(i, 200) == 0
            Index = i + 1;
            save('check-point.mat', 'CVStat', 'CVTime', 'Index');
        end
    end
    
end
