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
    Vx = rand(k, n);
    Vy = unique(Y);
    % ���ø��±��
    for Iter = 1 : MaxIter
        % ���ѡȡһ������
        j = randperm(m, 1);
        % ����������ÿ��ԭ�������ľ���
        PX = X(j) - Vx;
        D = sqrt(sum(PX.*PX, 2));
        % �ҳ���x�����ԭ������p
        [~, i] = min(D);
        % ���x��p�������ͬ
        if Y(j) == Vy(i)
            % p��x��£
            Vx(i, :) = Vx(i, :) + alpha * (X(j) - Vx(i, :));
        else
            % pԶ��x
            Vx(i, :) = Vx(i, :) - alpha * (X(j) - Vx(i, :));
        end
    end
    C = Y;
    V = [Vx, Vy];
end