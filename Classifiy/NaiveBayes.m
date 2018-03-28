classdef NaiveBayes
    %NAIVEBAYES �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��

    properties
        F;     % ���������ɢ1/����0
        Pc;    % �������
        CP;    % ��������
        Cell;  % ��ɢ����ת����
    end

    methods
        function [ clf ] = NaiveBayes(F)
            clf.F = F;
        end
        function [ clf ] = Fit(clf, X, Y, F)
            % Ԥ����
            [ Dp, Cell ] = NaiveBayes.Prepare([X, Y], F);
            [ Dx, Dy ] = SplitDataLabel(Dp, 9);
            C = unique(Dy);
            % ѵ��
            C = sort(C);
            Cn = length(C);
            [m, n] = size(Dx);
            % ��ʼ����ɢ����ת����
            clf.Cell = Cell;
            % ��ʼ���������
            clf.F = F;
            % ��ʼ���������
            clf.Pc = histc(Dy, C)/m;
            % Ϊÿ�����Թ�����������
            clf.CP = cell(Cn, n);
            % ��ÿһ�ַ���
            for i = 1 : Cn
                % �õ��÷�����Ӽ�
                Si = Dx(Dy==C(i), :);
                % ��ÿһ������j
                for j = 1 : n
                    Sij = Si(:, j);
                    % ����j����ɢ����
                    if F(j) == 1
                        Fij = sort(unique(Sij));
                        Fn = length(Fij);
                        Fpc = zeros(Fn, 1);
                        % �����Ե�ÿһ��ȡֵ
                        for k = 1 : Fn
                            Sijk = Si(Si(:, j) == Fij(k));
                            % P(ɫ��=����|�ù�=��)
                            Fpc(k) = length(Sijk)/length(Si);
                        end
                        % ��������
                        clf.CP{i, j} = Fpc;
                    else
                        % ����ֵ�ͷ���
                        clf.CP{i, j} = [mean(Sij), var(Sij)];
                    end
                end
            end
        end
        function [ clf, Yp ] = Predict(clf, X)
            % Ԥ����
            [ Xp ] = NaiveBayes.Transform(X, clf.F, clf.Cell);
            [~, n] = size(Xp);
            % Ԥ����
            Yn = length(clf.Pc);
            Yp = ones(1, Yn);
            % ��ÿһ�ַ���
            for i = 1 : Yn
                % �������
                Yp(i) = clf.Pc(i);
                % ��������
                for j = 1 : n
                    % �õ�i����j�������������ʱ�
                    CPij = clf.CP{i, j};
                    % �������ɢ����
                    if clf.F(j) == 1
                        % �������
                        Yp(i) = Yp(i) * CPij(Xp(j));
                    else
                        % �õ���ֵ������
                        Mean = CPij(1);
                        Var = CPij(2);
                        % ������̬�ֲ��������
                        Yp(i) = 1/(sqrt(2*pi*Var))*exp(-(Xp(j)-Mean)^2/(2*Var));
                    end
                end
            end
        end
    end
    methods(Static)
        function [ Dp, Cell ] = Prepare(D, F)
            [m, n] = size(D);
            Dp = zeros(m, n);
            % ��ɢ����ת����
            Cell = cell(n, 1);
            % ��ÿһ������
            for i = 1 : n
                % �������������
                if F(i) == 0
                    % ֱ�ӿ���
                    Dp(:, i) = cell2mat(D(:, i));
                else
                    % ��ȡ��ɢ����ֵ
                    Di = D(:, i);
                    Ci = unique(Di);
                    Ci = sort(Ci);
                    Cn = length(Ci);
                    Cell{i} = Ci;
                    % ת����ɢ����ֵ����
                    for j = 1 : Cn
                        Dp(strcmp(Di, Ci{j}), i) = j;
                    end
                end
            end
        end
        function [ Xp ] = Transform(X, F, Cell)
            % �õ�����ά��
            [~, n] = size(X);
            Xp = zeros(1, n);
            % ��ÿһ������
            for i = 1 : n
                % �������������
                if F(i) == 0
                    % ֱ�ӿ���
                    Xp(i) = X{i};
                else
                    % ת����ɢ����ֵ����
                    Xp(i) = find(strcmp(Cell{i}, X{i}));
                end
            end
        end
    end
end