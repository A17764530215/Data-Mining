function [ Stat, CVStat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
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

    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    fprintf('GridSearchCV: %d Params\n', nParams);
    
    % ��������
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        % ���ò���
        Params = GetParams(IParams, i);
        Params.solver = solver;
        % ������֤
        CVStat(i,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    
    Stat = GSStatistics(TaskNum, CVStat);

end
