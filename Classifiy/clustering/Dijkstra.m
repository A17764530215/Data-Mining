function [ distance, path ] = Dijkstra( D, start )
%DIJKSTRA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    [m, ~] = size(D);
    % initialize.
    distance = D(start, :);
    path = repmat(start, 1, m);
    visited = zeros(1, m);
    % start search.
    visited(start) = 1;
    for i = 1 : m
        % ������������δ���ʵ�
        uids = find(visited==0);
        [min_d, id] = min(distance(uids));
        mid = uids(id);
        % ���mid�ѷ���
        visited(mid) = 1;
        % ��δ���ʵģ���Ϊmid�����˾����mids�㣬�޸ľ����·��
        for k = 1 : m
            d = min_d + D(mid, k);
            if visited(k) == 0 && d < distance(k)
                distance(k) = d;
                path(k) = mid;
            end
        end
    end
end