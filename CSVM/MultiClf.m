classdef MultiClf
    %MULTICLF �˴���ʾ�йش����ժҪ
    % ����������
    %   �˴���ʾ��ϸ˵��

    properties (Access = 'public')
        Name;     % ����������
        nClasses; % �������
        Clfs;     % ������
        Lables;   % �������
        Params;   % ���������в���
    end

    methods (Access = 'public')
        function [ clf ] = MultiClf(Clf, nClasses, Labels)
            clf.Name = ['Multi-', Clf.Name];
            clf.nClasses = nClasses;
            clf.Clfs = repmat(Clf, nchoosek(nClasses, 2), 1);
            clf.Lables = Labels;
            clf.Params = struct(Clf);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
        %FIT �˴���ʾ�йش˺�����ժҪ
        % ѵ��
        %   �˴���ʾ��ϸ˵��
        % ������
        %     xTrain    -ѵ������
        %     yTrain    -ѵ����ǩ
        % ���أ�
        %       Time    -ѵ��ʱ��

            % OvO����
            nIndex = 0;
            % ��ʼ��ʱ
            tic;
            % ��ʼѵ��
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    % ѡȡ��nIndex��������
                    Clf = clf.Clfs(nIndex);
                    % ����OvO����
                    [ XTrain, YTrain ] = MultiClf.OvO(xTrain, yTrain, clf.Lables, i, j);
                    [ Clf, ~ ] = Clf.Fit(XTrain, YTrain);
                    % ���������ѵ�����
                    clf.Clfs(nIndex) = Clf;
                end
            end
            % ֹͣ��ʱ
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
        %PREDICT �˴���ʾ�йش˺�����ժҪ
        % ������������
        % ������
        %     clf    -������
        %       X    -����
        % ���أ�
        %   yTest    -Ԥ����
            % ����OvO����Ԥ��
            [m, ~] = size(xTest);
            [n, ~] = size(clf.Clfs);
            % �������
            YTests = zeros(m, n);
            % ����OvO�����
            nIndex = 0;
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    % ѡȡ��nIndex��������
                    Clf = clf.Clfs(nIndex);
                    % ����Ԥ��
                    [YTest] = Clf.Predict(xTest);
                    % ת���ڲ�������
                    YTest(YTest==1) = i;
                    YTest(YTest==-1) = j;
                    % ��¼��ʵ������
                    YTests(:, nIndex) = YTest;
                end
            end
            yTest = zeros(m, 1);
            yVote = zeros(1, clf.nClasses);
            for i = 1 : m
                % ͳ�Ʒ����Ʊ
                for j = 1 : clf.nClasses
                    yVote(1, j) = sum(YTests(i, :) == j);
                end
                % �Է����Ʊ��������
                [~, IDX] = sort(yVote(1, :), 'descend');
                % ѡȡ��Ʊ������һ����Ϊ������
                yTest(i) = clf.Lables(IDX(1));
            end
        end
        function [ clf ] = SetParams(clf, params)
            % ���÷���������
            clf.Params = params;
            nIndex = 0;
            % ��ʼ�����з������Ĳ���
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    Clf = clf.Clfs(nIndex);
                    Clf.SetParams(params);
                    clf.Clfs(nIndex) = Clf;
                end
            end
        end
        function [ params ] = GetParams(clf)
            % �õ�����������
            params = clf.Params;
        end
        function disp(clf)
            fprintf('%s: %d Classes\n', clf.Name, clf.nClasses);
        end
    end
    methods (Static)
        function [ Xr, Yr ] = OvO( X, Y, Lables, i, j )
            %OvO �˴���ʾ�йش˺�����ժҪ
            % i��Ϊ����㣬j�����
            %   �˴���ʾ��ϸ˵��

            Ip = Y==Lables(i);
            In = Y==Lables(j);
            Xp = X(Ip, :);
            Yp = ones(length(Xp), 1);
            Xn = X(In, :);
            Yn = -ones(length(Xn), 1);
            Xr = [Xp; Xn];
            Yr = [Yp; Yn];
        end
        function [ Xr, Yr ] = OvR( X, Y, Lables, i)
            %OvO �˴���ʾ�йش˺�����ժҪ
            % i��Ϊ����㣬���ฺ���
            %   �˴���ʾ��ϸ˵��
            Ip = Y==Lables(i);
            In = Y~=Lables(i);
            Xp = X(Ip, :);
            Yp = ones(length(Xp), 1);
            Xn = X(In, :);
            Yn = -ones(length(Xn), 1);
            Xr = [Xp; Xn];
            Yr = [Yp; Yn];
        end
    end
end