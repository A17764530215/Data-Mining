classdef KSVM
    %KSVM �˴���ʾ�йش����ժҪ
    % Kernel Support Vector Machine
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name;   % ����
        C;      % ����
        Kernel; % �˺���
        p1;     % �˲���1
        p2;     % �˲���2
        p3;     % �˲���3
    end
    
    properties (Access = 'private')
        xTrain; % ѵ������
        yTrain; % ��������
        Alpha;  % ѵ�����
    end
    
    methods (Access = 'public')
        function [ clf ] = KSVM(C, Kernel, p1, p2, p3)
        %KSVM �˴���ʾ�йش˺�����ժҪ
        % KSVM
        %   �˴���ʾ��ϸ˵��
            clf.Name = 'KSVM';
            clf.C = C;
            clf.Kernel = Kernel;
            if strcmp('linear', Kernel) == 0
                if nargin > 2
                    clf.p1 = p1;
                end
                if nargin > 3
                    clf.p2 = p2;
                end
                if nargin > 4
                    clf.p3 = p3;
                end
            end
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % ��ʱ
            tic
            % ��¼X, Y
            clf.xTrain = xTrain;
            clf.yTrain = yTrain;
            [m, ~] = size(xTrain);
            % �˾���
            K = Utils.K(clf.Kernel, xTrain, xTrain, clf.p1, clf.p2, clf.p3);
            % ������
            a = -ones(m, 1);
            lb = zeros(m, 1);
            ub = clf.C*ones(m, 1);
            H = diag(yTrain)*K*diag(yTrain);
            H = Utils.Cond(H);
            % ���ι滮���
            [ clf.Alpha ] = quadprog(H, a, [], [], [], [], lb, ub, [], []);
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            % �˾���
            K = Utils.K(clf.Kernel, xTest, clf.xTrain, clf.p1, clf.p2, clf.p3);
            % Ԥ��ֵ
            yTest = sign(K*diag(clf.yTrain)*clf.Alpha);
            % ��0����1
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
end