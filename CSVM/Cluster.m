function [ C, V, T ] = Cluster( X, Y, name, k )
%CLUSTER �˴���ʾ�йش˺�����ժҪ
% �����㷨
%   �˴���ʾ��ϸ˵��
% ������
%      X   -����
%      Y   -������ǩ
%   name   -���෽��
%      k   -�������
% �����
%      C   -�ػ���
%      V   -��������
%      T   -����ʱ��
%

    tic;
    V = [];
    switch(name)
        case {'Initial'}
            [ C ] = Y;
        case {'KMeans'}
            [ C, V ] = KMeans( X, k );
        case {'LVQ'}
            [ C, V ] = LVQ( X, Y, k, 0.2, 2000 );
        case {'AGNES'}
            [ C ] = AGNES( X, k, 'min' );
        case {'BiKMeans'}
            [ C ] = BiKMeans( X, 32, k );
    end
    % ���û�м����������
    if isempty(V)
        % �����������
        Vy = unique(C);
        [~, n] = size(X);
        Vx = zeros(k, n);
        for i = 1 : k
            Vx(i, :) = mean(X(C==Vy(i), :));
        end
        % �����������
        V = [Vx, Vy];
    end
    T = toc;
end