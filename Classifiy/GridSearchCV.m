function [ Output ] = GridSearchCV( Learner, X, Y, Kfold, ValInd, IParams, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ��������������֤
%   �˴���ʾ��ϸ˵��
% ������
%   Learner    -������
%         X    -����
%         Y    -��ǩ
%    Params    -��������
%     Kfold    -K�۽�����֤
% �����
%    Output    -����������������֤���

    % �õ���������
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    % ��ÿһ�����
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        % ������֤
        opts.Params = IParams(i);
        [ Accuracy, Precision, Recall, Time ] = CrossValid(Learner, X, Y, ValInd, Kfold, opts);
        % ������
        Output(i, :) = [Accuracy Precision Recall Time];
    end
end