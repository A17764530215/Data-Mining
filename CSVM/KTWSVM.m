classdef KTWSVM
    %KTWSVM �˴���ʾ�йش����ժҪ
    % Kernel Twin Support Vector Machine
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name;   % ����������
        C1;     % ����1
        C2;     % ����2
        Kernel; % �˺���
    end
    
    properties (Access = 'private')
        C;  % [A;B]
        u1; % KTWSVM1
        b1; % KTWSVM1
        u2; % KTWSVM2
        b2; % KTWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = KTWSVM(params)
            clf.Name = 'KTWSVM';
            if nargin == 1
                clf = clf.SetParams(params);
            end
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % ��ʱ
            tic
            % �ָ��������
            A = xTrain(yTrain==1, :);
            B = xTrain(yTrain==-1, :);
            [m1, ~] = size(A);
            [m2, ~] = size(B);
            n = m1 + m2;
            e1 = ones(m1, 1);
            e2 = ones(m2, 1);
            % ����˾���
            clf.C = [A; B];
            S = [clf.Kernel.K(A, clf.C) e1];
            R = [clf.Kernel.K(B, clf.C) e2];
            S2 = S'*S;
            R2 = R'*R;
            % KDTWSVM1
            H1 = R/S2*R';
            H1 = Utils.Cond(H1);
            lb1 = zeros(m2, 1);
            ub1 = ones(m2, 1)*clf.C1;
            Alpha = quadprog(H1,-e2,[],[],[],[],lb1,ub1);
            z1 = -S2\R'*Alpha;
            clf.u1 = z1(1:n);
            clf.b1 = z1(end);
            % KDTWSVM2
            H2 = S/R2*S';
            H2 = Utils.Cond(H2);
            lb2 = zeros(m1, 1);
            ub2 = ones(m1, 1)*clf.C2;
            Mu = quadprog(H2,-e1,[],[],[],[],lb2,ub2);
            z2 = -R2\S'*Mu;
            clf.u2 = z2(1:n);
            clf.b2 = z2(end);
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            K = clf.Kernel.K(xTest, clf.C);
            D1 = abs(K*clf.u1+clf.b1);
            D2 = abs(K*clf.u2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % ���÷���������
            clf.C1 = params.C1;
            clf.C2 = params.C2;
            clf.Kernel.SetParams(params.Kernel);
        end
        function [ params ] = GetParams(clf)
            % �õ�����������
            params = struct(clf);
            kernel = params.Kernel.GetParams(params);
            params = rmfield(params, 'Kernel');
            params = MergeStruct(params, kernel);
        end
        function disp(clf)
            fprintf('%s: C1=%4.5f\tC2=%4.5f\n', clf.Name, clf.C1, clf.C2);
        end
    end

end