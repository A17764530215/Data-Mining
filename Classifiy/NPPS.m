function [ Xr, Yr, W ] = NPPS( X, Y, k )
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
    W = zeros(m, 1);
    for i = 1 : m
        % ��������ء�����ƥ��
        [ ~, entropy, match, J ] = NP( Y, M, i, k );
        % ѡ������ش���0������ƥ�����1/J��������
        if (entropy > 0) && (match >= 1/J)
            samples(i, :) = 1;
        else
            samples(i, :) = 0;
        end
        W(i) = entropy*match; % ������*����ƥ����Ϊ������Ȩ��
    end
    % �õ���ѡ����������±�
    idx = find(samples == 1);
    Xr = X(idx, :); Yr = Y(idx, :);
end