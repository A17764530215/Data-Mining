function [ CVStat, CVTime ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ���������������������֤
%   �˴���ʾ��ϸ˵��

    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 8, TaskNum);
    CVTime = zeros(nParams, 2);
    
    fprintf('GridSearchCV: %d Params\n', nParams);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        Params = GetParams(IParams, i);
        Params.solver = solver;
        [CVStat(i,:,:), CVTime(i,:)]= CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    
end