function [ Output ] = GridSearch( Clf, X, Y, ValInd, k, P1, P2 )
%GRIDSEARCH �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
% ������
%     Clf   -������
%       D   -���ݼ�
%       k   -k��
%  Params   -��������
% �����
%  Output   -����������������֤���

    nP1 = length(P1);
    nP2 = length(P2);
    nIndex = 0;
    Output = cell(nP1*nP2, 6);
    for i = 1 : nP1
        for j = 1 : nP2
            nIndex = nIndex + 1;
            % ������֤
            [ Accuracy, Precision, Recall, Time ] = CrossValid(Clf, X, Y, ValInd, k);
            % ������
            Output(nIndex, :) = {
                P1(i), P2(j), Accuracy, Precision, Recall, Time
            };
        end
    end
end