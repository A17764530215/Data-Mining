function [ Output ] = GridSearch( D, n, C, Sigma )
%GRIDSEARCH �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
% ������
%      D    -���ݼ�
%      n    -n�۽�����֤
%      C    -����C����
%  Sigma    -����������

    nC = length(C);
    nS = length(Sigma);
    nIndex = 0;
    Output = zeros(nC*nS, 5);
    for i = 1 : nC
        for j = 1 : nS
            nIndex = nIndex + 1;
            [ Recall, Precision, Accuracy, ~, ~ ] = CrossValid( D, n, C{i}, Sigma{j} );
            Output(nIndex, :) = [ C{i}, Sigma{j}, Recall, Precision, Accuracy ];
        end
    end
end