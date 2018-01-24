function [ idx, entropy, match, J ] = NeighborsProperty( X, Y, M, x, k )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   X    -���ݼ�
%   M    -�������
%   x    -����x
%   k    -������
%   �˴���ʾ��ϸ˵��
    % ͳ�������
    class = unique(Y);
    J = length(class);
    % ���x��k����
    [~, idx] = sort(M(x,:), 'ascend');
    idx = idx(:,2:1+k);
    % ����x�Ľ�����
    entropy = 0;
    for i = 1 : J
        % ͳ��x��k������i�����
        x_j = find(Y(idx)==class(i));
        p_i = length(x_j)/k;
        entropy = entropy + p_i*log2(1/p_i);
    end
    % ����x�Ľ���ƥ��
    x_j = find(Y(idx)==Y(x));
    match = length(x_j)/k;
end