classdef AdaBoost
    %ADABOOST �˴���ʾ�йش����ժҪ
    % AdaBoost.M1
    %   �˴���ʾ��ϸ˵��
    
    properties (Access = 'public')
        Name; % ����������
        M;    % ����������Ŀ
    end
    
    properties (Access = 'private')
        Clfs;  % ������������
        Alpha; % ������Ȩ��
    end
    
    methods (Access = 'public')
        function [ clf ] = AdaBoost(Clfs)
            clf.Name = 'ADABOOST';
            clf.M = length(Clfs);
            clf.Clfs = Clfs;
            clf.Alpha = ones(clf.M, 1)/clf.M;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % ��ʱ
            tic
            % AdaBoost
            [m, ~] = size(xTrain);
            % ��ʼ��ѵ�����ݵ�Ȩֵ�ֲ�
            W = ones(m, 1)/m;
            % ��m = 1,2,...,M
            for i = 1 : clf.M
                Clf = clf.Clfs{i};
                % ʹ�þ���Ȩֵ�ֲ�Dm�ĵ�ѵ�����ݼ�ѧϰ���õ�����������
                Clf = Clf.Fit(xTrain, yTrain);
                % ���������i
                clf.Clfs{i} = Clf;
                % ����Gm��ѵ�����ݼ��ϵķ��������
                yPred = Clf.Predict(xTrain);
                % ��Ȩ��׼��������
                Error = sum(W(yPred~=yTrain))/sum(W);
                % ����Gm��ϵ��
                clf.Alpha(i) = 0.5*log((1-Error)/Error);
                % ����ѵ�����ݼ���Ȩֵ�ֲ�
                W = W*exp(-clf.Alpha(i)*(yTrain~=yPred));
            end
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            [m, ~] = size(xTest);
            % ����ÿ��������Ԥ����
            yPred = zeros(m, clf.M);
            % ÿһ��������������һ��Ԥ��
            for i = 1 : clf.M
                Clf = clf.Clfs(i);
                yPred(:, i) = Clf.Predict(xTest);
            end
            % ����������������������ϣ��õ����շ�����
            yTest = sign(yPred*clf.Alpha);
        end
        function disp(clf)
            fprintf('%s: M=%d\n', clf.Name, clf.M);
        end
    end
end