function [ idx, dist, M ] = mKNN( X, k )
%MKNN �˴���ʾ�йش˺�����ժҪ
% Mutual K Nearest Neighbours
%   �˴���ʾ��ϸ˵��
% ������
%     X    -���ݼ�
%     k    -������
% �����
%   idx    -��������k���ھ���
%  dist    -��������k���ھ������
%     M    -mutual KNN Graph

    [m, ~] = size(X);
    % ����໥�����
    [idx, dist] = knnsearch(X, X, 'K', k + 1,'Distance','euclidean');
    idx = idx(:, 2:k + 1);
    dist = dist(:, 2:k + 1);
    % ����mutual KNN Graph
    M = Inf(m, m); % zeros(m, m); % spalloc(m, m, 2*k*m);
    for i = 1 : m
        M(i, idx(i, :)) = dist(i, :);
    end
end