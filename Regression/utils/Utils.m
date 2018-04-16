classdef Utils
    %UTILS �˴���ʾ�йش����ժҪ
    % ���߼�
    %   �˴���ʾ��ϸ˵��
    
    properties
    end
    
    methods (Static)
        function [ idx, dist, M ] = KnnGraph( X, k )
        %MKNN �˴���ʾ�йش˺�����ժҪ
        % Mutual K Nearest Neighbours
        %   �˴���ʾ��ϸ˵��
        % ������
        %     X    -���ݼ�
        %     k    -������
        % �����
        %   idx    -��������k���ھ���
        %  dist    -��������k���ھ������
        %     M    -Mutual KNN Graph

            [m, ~] = size(X);
            % ����໥�����
            [idx, dist] = knnsearch(X, X, 'K', k + 1,'Distance','euclidean');
            idx = idx(:, 2:k + 1);
            dist = dist(:, 2:k + 1);
            % ����Mutual KNN Graph
            M = zeros(m, m); % zeros(m, m); % spalloc(m, m, 2*k*m);
            for i = 1 : m
                M(i, idx(i, :)) = 1;%dist(i, :);
            end
            M = (M + M')/2;
        end
    end
end