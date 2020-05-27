function [ V ] = ClusterCenter( X, C )
%CLUSTERCENTER �˴���ʾ�йش˺�����ժҪ
% �����������
%   �˴���ʾ��ϸ˵��
% ������
%      X    -���ݼ�
%      C    -�ػ���
    Vy = unique(C);
    [~, n] = size(X);
    Vx = zeros(k, n);
    for i = 1 : k
        Xi = X(C==Vy(i), :);
        if length(Xi) == 1
            Vx(i, :) = Xi;
        else
            Vx(i, :) = mean(Xi);
        end
    end
    % �����������
    V = [Vx, Vy];
end

