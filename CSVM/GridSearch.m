function [ Output ] = GridSearch( Clf, X, Y, ValInd, k, Params )
%GRIDSEARCH �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
% ������
%      Clf    -������
%        D    -���ݼ�
%   ValInd    -������֤����
%        K    -K��
%   Params    -��������
% �����
%   Output    -����������������֤���

    nP = length(Params);
    Outputs = cell(nP, 6);
    for i = 1 : nP
        % ���ò���
        Clf = Clf.SetParams(Params(i));
        % ������֤
        [ Accuracy, Precision, Recall, Time ] = CrossValid(Clf, X, Y, ValInd, k);
        % ������
        Output = Clf.GetParams();
        Output.Accuracy = Accuracy;
        Output.Precision = Precision;
        Output.Recall = Recall;
        Output.Time = Time;
        Outputs(i, :) = Output;
    end
end