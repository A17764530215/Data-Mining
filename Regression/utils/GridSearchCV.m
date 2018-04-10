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
    nParams = length(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % ��������
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        % ���ò���
        Params = IParams(i);
        Params.solver = solver;
        % ������֤
        CVStat(i,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = CVStatistics(TaskNum, CVStat);
    
    function [ OStat ] = CVStatistics(TaskNum, IStat)
        % ������֤ͳ��ÿһ������
        OStat = zeros(TaskNum, 4, 2);
        for t = 1 : TaskNum
            [V, I] = min(IStat(:,:,t));
            OStat(t,:,:) = [V, I];
        end
    end
end