classdef Utils
    %UTILS �˴���ʾ�йش����ժҪ
    % ���߼�
    %   �˴���ʾ��ϸ˵��
    
    properties
    end
    
    methods (Static)
        function [ Y ] = K( Kernel, U, V, p1, p2, p3 )
        %KERNEL �˴���ʾ�йش˺�����ժҪ
        % �˺���
        %   �˴���ʾ��ϸ˵��
        % ������
        %     Kernel    -�˺���
        %     U         -����U
        %     V         -����V
        %     p1~p3     -�˺�������

            switch Kernel
                case 'linear'
                    % Linear Kernel
                    % disp('You are using a Linear Kernal')
                    Y = U*V.';
                case 'poly'
                    % Polynomial Kernel
                    % disp('You are using a Polynomial Kernal')
                    Y = (p1*U*V'+p2).^p3;
                case 'rbf'
                    % Gaussian Kernel
                    % disp('You are using a RBF Kernal')
                    D = XYDist(U, V);
                    Y = exp(-D.^2/(2*p1.^2));
                case 'sigmoid'
                    % Sigmoid Kernel
                    Y = tanh(p1*U*V'+p2);
                case 'log'
                    % Log Kernel
                    D = XYDist(U, V);
                    Y = -log(1+D.^p1);
                otherwise
                    disp('Please enter a Valid kernel choice ')
                    Y = [ ];
            end
        end
        function [ A ] = Cond( H )
        %COND �˴���ʾ�йش˺�����ժҪ
        % �����˾���
        %   �˴���ʾ��ϸ˵��
        % ������
        %     H     -�˾���
        %     A     -���������

            if (abs(cond(H)) > 1e+10)
                A = H + 0.00000001*eye(size(H));
            else
                A = H;
            end            
        end
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