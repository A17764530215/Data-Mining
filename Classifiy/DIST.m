function [ matrix ] = DIST( X )
%DIST �˴���ʾ�йش˺�����ժҪ
%   ����������
%   �˴���ʾ��ϸ˵��
%   X        -�������ݼ�
%   matrix   -���ƶȾ���
    % ��ʼ����������ѷ��ʱ���С������
    [m,~] = size(X);
    matrix = zeros(m,m);
    % �����֮��ľ���
    for i = 1 : m
        for j = i + 1 : m
            d = norm(X(i,:)-X(j,:));
            matrix(i,j) = d;
            matrix(j,i) = d;
        end
    end
end

