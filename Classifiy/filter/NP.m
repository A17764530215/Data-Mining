function [ idx, entropy, match, J ] = NP( Y, M, x, k )
%NeighborsProperty �˴���ʾ�йش˺�����ժҪ
% ��������
%   �˴���ʾ��ϸ˵��
%   Y    -��ǩ��
%   M    -�������
%   x    -����x
%   k    -������

    % ͳ�������
    class = unique(Y);
    J = length(class);
    % ���x��k����
    idx = KNN(M, x, k);
    % ����x�Ľ�����
    entropy = 0;
    for j = 1 : J
        % ͳ��x��k������i�����
        x_j = find(Y(idx)==class(j));
        k_j = length(x_j);
        p_j = k_j/k;
        % ��ֹ���ʼ������
        if p_j > 0
            entropy = entropy - p_j*log2(p_j);
        end
    end
    % ����x�Ľ���ƥ��
    x_j = find(Y(idx)==Y(x));
    match = length(x_j)/k;
end