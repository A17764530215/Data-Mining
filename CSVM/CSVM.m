classdef CSVM
    %CSVM �˴���ʾ�йش����ժҪ
    % Kernel Support Vector Machine
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name;   % ����
        C;      % ����
        Kernel; % �˺���
    end

    properties (Access = 'private')
        xTrain; % ѵ������
        yTrain; % ��������
        Alpha;  % ѵ�����
    end
    
    methods (Access = 'public')
        function [ clf ] = CSVM(params)
        %CSVM �˴���ʾ�йش˺�����ժҪ
        % CSVM
        %   �˴���ʾ��ϸ˵��
            clf = clf.SetParams(params);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % ��ʱ
            tic
            % ��¼X, Y
            clf.xTrain = xTrain;
            clf.yTrain = yTrain;
            [m, ~] = size(xTrain);
            % �˾���
            K = clf.Kernel.K(xTrain, xTrain);
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
            K = clf.Kernel.K(xTest, clf.xTrain);
            % Ԥ��ֵ
            yTest = sign(K*diag(clf.yTrain)*clf.Alpha);
            % ��0����1
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % ���÷���������
            clf.Name = params.Name;
            clf.C = params.C;
            clf.Kernel = FKernel(params.Kernel);
        end
        function [ params ] = GetParams(clf)
            % �õ�����������
            kernel = clf.Kernel.GetParams();
            params = struct(clf);
            params = rmfield(params, 'Kernel');
            params = MergeStruct(params, kernel);
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
    
end