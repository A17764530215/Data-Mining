classdef FSVM
    %Field SVM �˴���ʾ�йش����ժҪ
    % Kernel Support Vector Machine
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name;   % ����
        C;      % ����
        T;      % TǨ�Ƴͷ�����
        Kernel; % �˺���
    end

    properties (Access = 'private')
        xTrain; % ѵ������
        yTrain; % ��������
        Alpha;  % ѵ�����
        SV;     % ֧������
        W;      % W;
    end
    
    methods (Access = 'public')
        function [ clf ] = FSVM(params)
        %CSVM �˴���ʾ�йش˺�����ժҪ
        % CSVM
        %   �˴���ʾ��ϸ˵��
            clf.Name = 'FSVM';
            clf = clf.SetParams(params);
        end
        function [ clf ] = SNTFit(clf, xTrain, yTrain, zTrain, zN)
            [~, n] = size(xTrain);
            % ����A����
            Aold = ones(n, n, zN);
            Anew = ones(n, n, zN);
            for i = 1 : zN
                Anew(:,:,i) = diag(ones(1, n));
                Aold = Anew;
            end
            % �������CSVM-Style Normalization Transformation (SNT)
            while (true)
                % 1. SNT ��ʽ�淶��ת��
                XTrain = FSVM.SNT(A, xTrain, zTrain, zN);
                % 2. CSVM Learning ��ת�����������ѵ��
                [ ~ ] = clf.Fit(XTrain, yTrain);
                % 3. SNT ѧϰ. ���ݹ�ʽ(5)���±任����A
                clf.W = clf.GetW(XTrain, yTrain, clf.Alpha);
                for i = 1 : zN
                    zi = find(zTrain==i); % ���ݹ�ʽ(5)���±任����Ai
                    Wi = clf.GetW(XTrain(zi,:), yTrain(zi,:), clf.Alpha(zi,:));
                    Anew(:,:,i) = clf.W*Wi'/(2*clf.T);
                end
                % 4. Check Convergence.  ���ѧ����SNT�仯���󣬾��˳�
                if norm(Anew-Aold, 'fro') > 0.0001
                    Aold = Anew;
                else
                    break;
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
            K = clf.Kernel.K(xTrain, xTrain);
            % ������
            a = -ones(m, 1);
            lb = zeros(m, 1);
            ub = clf.C*ones(m, 1);
            H = diag(yTrain)*K*diag(yTrain);
            H = Utils.Cond(H);
            % ���ι滮���
            [ clf.Alpha ] = quadprog(H, a, [], [], [], [], lb, ub, [], []);
            clf.SV = clf.Alpha > 0;
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ W ] = GetW(clf, xTrain, yTrain, Alpha)
            svi = find(Alpha > 0);
            XTrain = xTrain(svi);
            YTrain = yTrain(svi);
            KXTrain = clf.Kernel.K(XTrain, xTrain);
            W = KXTrain*diag(YTrain)*Alpha;
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
            clf.C = params.C;
            clf.T = params.T;
            clf.Kernel = FKernel(params.Kernel);
        end
        function [ params ] = GetParams(clf)
            % �õ�����������
            params = struct(clf);
            kernel = params.Kernel.GetParams();
            params = rmfield(params, 'Kernel');
            params = MergeStruct(params, kernel);
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
    
    methods (Static)        
        function [ xTrain ] = SNT(A, xTrain, zTrain, zN)
            % Iteration.
            % SNT
            for i = 1 : zN
                xTrain(zTrain==i,:) = A(:,:,i)*xTrain(zTrain==i,:);
            end
        end
    end
    
end