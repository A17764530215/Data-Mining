function [ Stat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
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
    nParams = length(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % ��������
    for idx = 1 : nParams
        fprintf('GridSearchCV: %d', idx);
        % ���ò���
        Params = IParams(idx);
        Params.solver = solver;
        % ������֤
        CVStat(idx,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = CVStatistics(TaskNum, CVStat);

    function [ OStat ] = CVStatistics(TaskNum, IStat)
        % ������֤ͳ��
        OStat = zeros(4, 2, TaskNum);
        for t = 1 : TaskNum
            for k = 1 : 4
                 OStat(k,:,t) = max(IStat(:,k,t));                 
            end
        end
    end
end