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
        % ������֤ͳ��
        OStat = zeros(4, 2, TaskNum);
        % ��ÿһ������
        for t = 1 : TaskNum
            % ��ÿһ��ͳ����
            for k = 1 : 4
                % �ҳ���Сֵ
                [val, idx] = min(IStat(:,k,t));
                OStat(k,:,t) = [val, idx];
            end
        end
    end
end