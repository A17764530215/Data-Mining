function [ Output ] = GridSearchCV( Learner, X, Y, Kfold, ValInd, IParams, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ��������������֤
%   �˴���ʾ��ϸ˵��
% ������
%    Learner    -ѧϰ��
%          X    -����
%          Y    -��ǩ
%     Params    -��������
%      Kfold    -K�۽�����֤
% �����
%     Output    -����������������֤���

    % �õ���������
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    % ��ÿһ�����
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        % ������֤
        Output(i, :) = CrossValid(Learner, X, Y, Kfold, ValInd, IParams(i), opts);
    end
end