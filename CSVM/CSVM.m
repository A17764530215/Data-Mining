classdef CSVM
    % C-֧��������
    properties (Access = 'public')
        C; % �ͷ�����
        Sigma; % RBF�˲���
    end
    properties (Access = 'private')
        X;
        Y;
        x;
    end
    methods (Access = 'public')
        function [ clf ] = CSVM(C, Sigma)
        %CSVM �˴���ʾ�йش˺�����ժҪ
        %   �˴���ʾ��ϸ˵��
            clf.C = C;
            clf.Sigma = Sigma;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % ��¼X, Y
            clf.X = xTrain;
            clf.Y = yTrain;
            [L, ~] = size(xTrain);
            % ��ʱ
            tic
            % �˾���
            K1 = exp(-(repmat(sum(xTrain.*xTrain, 2)', L, 1)+repmat(sum(xTrain.*xTrain, 2), 1, L)-2*(xTrain*xTrain'))/(2*clf.Sigma^2));
            H = diag(yTrain)*K1*diag(yTrain);
            % ������
            a = -ones(L, 1);
            % ���½�
            lb = zeros(L, 1);
            ub = clf.C*ones(L, 1);
            % ѡ��
            opts = []; 
            % ���ι滮���
            [ clf.x ] = quadprog(H, a, [], [], [], [], lb, ub, [], opts);
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            xTrain = clf.X;
            yTrain = clf.Y;
            [L, ~] = size(xTrain);
            [s, ~] = size(xTest);
            % �˾���
            KT = exp(-(repmat(sum(xTest.*xTest, 2)', L, 1)+repmat(sum(xTrain.*xTrain, 2), 1, s) - 2*xTrain*xTest')/(2*clf.Sigma^2));
            KT = KT';
            % f(x) = kernel(X, x) * Y * x
            PY = KT*diag(yTrain)*clf.x;
            % Ԥ��ֵ
            yTest = sign(PY);
            % ��0����1
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('C-SVM: C=%4.5f\tSigma=%4.5f\n', clf.C, clf.Sigma);
        end
    end
end