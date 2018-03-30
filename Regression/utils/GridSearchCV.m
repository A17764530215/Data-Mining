function [ Output ] = GridSearchCV( Learner, X, Y, ValInd, IParams, Kfold )
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
        O = CrossValid(Learner, X, Y, ValInd, Kfold, IParams(i), opts);
        % ������
        Output(i, :) = O;
    end
end