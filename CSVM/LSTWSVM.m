classdef LSTWSVM
    %LSTWSVM �˴���ʾ�йش����ժҪ
    % Least Square Twin Support Vector Machine
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name;   % ����������
        C1;     % ����1
        C2;     % ����2
        Kernel; % �˺���
        p1;     % �˲���1
        p2;     % �˲���2
        p3;     % �˲���3
    end
    
    properties (Access = 'private')
        C;  % [A;B]
        w1; % TWSVM1
        b1; % TWSVM1
        w2; % TWSVM2
        b2; % TWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = LSTWSVM(C1, C2, Kernel, p1, p2, p3)
            clf.Name = 'LSTWSVM';
            clf.Kernel = Kernel;
            clf.C1 = C1;
            clf.C2 = C2;
            if strcmp('linear', Kernel) == 0
                if nargin > 3
                    clf.p1 = p1;
                end
                if nargin > 4
                    clf.p2 = p2;
                end
                if nargin > 5
                    clf.p3 = p3;
                end
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
%             E = [A e1];
%             F = [B e2];
            E = [Utils.K(clf.Kernel, A, clf.C, clf.p1, clf.p2, clf.p3) e1];
            F = [Utils.K(clf.Kernel, B, clf.C, clf.p1, clf.p2, clf.p3) e2];
            E2 = E'*E;
            F2 = F'*F;
            % LS-TWSVM1
            u1 = -(F2+1/clf.C1*E2)\F'*e2;
            clf.w1 = u1(1:n);
            clf.b1 = u1(end);
            % LS-TWSVM2
            u2 = +(E2+1/clf.C2*F2)\E'*e1;
            clf.w2 = u2(1:n);
            clf.b2 = u2(end);
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
%             D1 = abs(xTest*clf.w1+clf.b1);
%             D2 = abs(xTest*clf.w2+clf.b2);
            K = Utils.K(clf.Kernel, xTest, clf.C, clf.p1, clf.p2, clf.p3);
            D1 = abs(K*clf.w1+clf.b1);
            D2 = abs(K*clf.w2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('%s: C1=%4.5f\tC2=%4.5f\n', clf.Name, clf.C1, clf.C2);
        end
    end
end