function [ mst ] = MST( X, start )
%MST �˴���ʾ�йش˺�����ժҪ
% ��С������
%   �˴���ʾ��ϸ˵��
    [m,~] = size(X);
    % ��ʼ����������ѷ��ʱ���С������
    matrix = zeros(m,m);
    visited = zeros(m,1);
    path = zeros(m,1);
    distance = zeros(m,1);
    % �����֮��ľ���
    for i = 1 : m
        for j = i + 1 : m
            d = norm(X(i,:)-X(j,:));
            matrix(i,j) = d;
            matrix(j,i) = d;
        end
    end
    % ��ʼ������ʼ��ľ��룬·��
    for i = 1 : m
        % ��һ�ڵ�Ϊstart
        path(i, 1) = start;
        % ����ʼ��ľ���
        distance(i, 1) = matrix(start, i);
    end
    % ���start�ѷ���
    visited(start,1) = 1;
    path(start,1) = start;
    distance(start,1) = 0;
    % ��С������Prim�㷨
    for i = 1 : m
        % ���뵱ǰ����������Ķ����minid
        min = Inf;
        mid = start;
        for j = 1 : m
            if visited(j,1) == 0 && distance(j) < min
                mid = j;
                min = distance(j,1);
            end
        end
        % �ص���ʼ��
        if mid == start
            break;
        end
        % ���minid�ѷ���
        visited(mid,1) = 1;
        % ����distance(j)����һ���ڵ�ľ���
        for j = 1 : m
            % ����ڵ�δ���ʣ��ҵ���ǰ���ʽڵ�������
            if visited(j) == 0 && matrix(mid,j) < distance(j,1)
                distance(j,1) = matrix(mid,j);
                path(j,1) = mid; 
            end
        end
    end
    mst = path;
end