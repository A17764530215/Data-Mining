function [ idx ] = NPPS( X, Y, k )
%NPPS �˴���ʾ�йش˺�����ժҪ
%   X    -���ݼ�
%   Y    -��ǩ��
%   k    -������
%   �˴���ʾ��ϸ˵��
    % �õ�ά��
    [m, ~] = size(X);
    % �õ�����
    M = DIST(X);
    % ɸѡ����
    samples = zeros(m, 1);
    for x = 1 : m
        % ��������ء�����ƥ��
        [ ~, entropy, match, J ] = NeighborsProperty( X, Y, M, x, k );
        % ѡ������ش���0������ƥ�����1/J��������
        if entropy > 0 && match >= 1/J
            samples(x, :) = 1;
        end
    end
    % �õ���ѡ����������±�
    idx = find(samples == 1);
end

