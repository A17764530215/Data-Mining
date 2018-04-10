function [ yTest, Time ] = LogRegression( xTrain, yTrain, xTest, opts)
%LOGREGRESSION �˴���ʾ�йش˺�����ժҪ
% Logistic Regression
%   �˴���ʾ��ϸ˵��

    Optimizer = opts.Optimizer;
    NumIter = opts.NumIter;
    
    % Logistic�ݶ��Ż�
    if Optimizer == 'SGA'
        W = SGA(xTrain, yTrain, NumIter);
    else
        W = BGA(xTrain, yTrain, NumIter);
    end
    
    

%% �����ݶ�����
    function [ W ] = BGA( X, Y, NumIter )
    %BGD �˴���ʾ�йش˺�����ժҪ
    %   �˴���ʾ��ϸ˵��
        if ismatrix(X) == 1
            [~, n] = size(X);
        end

        alpha = 0.001;
        W = ones(n, 1);

        for k = 1 : NumIter
            H = Sigmoid(X * W);
            E = Y - H;
            W = W + alpha * X.' * E; % һ���ݶ�
            % ����ţ�ٷ�
    %         D1 = -X.'*E;
    %         D2 = X.'.*X.*H.*(1-H);
    %         W = W + alpha * D2\D1;
        end
    end

%% ����ݶ�����
    function [ W ] = SGA( X, Y, NumIter )
    %SGA �˴���ʾ�йش˺�����ժҪ
    %   �˴���ʾ��ϸ˵��
        if ismatrix(X) == 1
            [m, n] = size(X);
        end
    %    alpha = 0.01;
        weights = ones(n);
        for j = 1 : NumIter
            for i = 1 : m
                alpha = 4 / (1.0 + j + i) + 0.01;
                rand_index = randperm(m, 1);
                h = Sigmoid(sum(X(rand_index) * weights));
                e = Y(rand_index) - h;
                weights = weights + alpha*e*X(rand_index);
            end
        end
        W = weights;
    end

end

