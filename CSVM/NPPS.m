function [ Xn, Yn ] = NPPS( X, Y, k )
%NPPS �˴���ʾ�йش˺�����ժҪ
% Neighbors Property Pattern Selection
%   �˴���ʾ��ϸ˵��
% ������
%   X    -���ݼ�
%   Y    -��ǩ��
%   k    -������

    % �õ�ά��
    [m, ~] = size(X);
    % �õ�����
    M = DIST(X);
    % ɸѡ����
    samples = zeros(m, 1);
    for x = 1 : m
        % ��������ء�����ƥ��
        [ ~, entropy, match, J ] = NP( Y, M, x, k );
        % ѡ������ش���0������ƥ�����1/J��������
        if (entropy > 0) && (match >= 1/J)
            samples(x, :) = 1;
        else
            samples(x, :) = 0;
        end
    end
    % �õ���ѡ����������±�
    idx = find(samples == 1);
    Xn = X(idx, :); Yn = Y(idx, :);
end
