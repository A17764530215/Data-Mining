function [ C, V ] = LVQ( X, Y, k, alpha, MaxIter )
%LVQ �˴���ʾ�йش˺�����ժҪ
% ѧϰ���������㷨
%   �˴���ʾ��ϸ˵��
% ������
%    X   -���ݼ�
%    Y   -��ǩ
%    q   -ԭ����������
%    t   -ԭ������Ԥ�������
% �����
%    C   -�ػ���
%    V   -��������

    [m, n] = size(X);
    % ��ʼ��һ��ԭ������
    V = rand(k, n);
    C = unique(Y);
    % ���ø��±��
    for Iter = 1 : MaxIter
        % ���ѡȡһ������
        j = randperm(m, 1);
        % ����������ÿ��ԭ�������ľ���
        PX = X(j) - V;
        D = sqrt(sum(PX.*PX, 2));
        % �ҳ���x�����ԭ������p
        [~, i] = min(D);
        % ���x��p�������ͬ
        if Y(j) == C(i)
            % p��x��£
            V(i, :) = V(i, :) + alpha * (X(j) - V(i, :));
        else
            % pԶ��x
            V(i, :) = V(i, :) - alpha * (X(j) - V(i, :));
        end
    end
end