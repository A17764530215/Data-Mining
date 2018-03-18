function [ Output ] = GridSearchCV( Clf, X, Y, ValInd, IParams, Kfold )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ��������������֤
%   �˴���ʾ��ϸ˵��
% ������
%      Clf    -������
%        X    -����
%        Y    -��ǩ
%   Params    -��������
%    Kfold    -K�۽�����֤
% �����
%   Output    -����������������֤���

    % �õ���������
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    % ��ÿһ�����
    for i = 1 : nParams
        % ���ò���
        Clf = Clf.SetParams(IParams(i));
        % ������֤
        [ Accuracy, Precision, Recall, Time ] = CrossValid(Clf, X, Y, ValInd, Kfold);
        % ������
        Output(i, :) = [Accuracy Precision Recall Time];
    end
end