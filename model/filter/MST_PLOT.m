function [ matrix, idx ] = MST_PLOT( X, mst )
%PLOT_MST �˴���ʾ�йش˺�����ժҪ
% ����MST��ת��MSTΪ�ڽӾ���
% �˴���ʾ��ϸ˵��
    [m,~] = size(X);
    matrix = zeros(m, m);
    reduce = zeros(m, 1);
    % ������С������
    for i = 1 : m
        u = i;
        v = mst(i, 1);
        % ���ڽӾ����ʾ��С������
        matrix(u, v) = 1;
        matrix(v, u) = 1;
        % ��¼������ݵ�
        if X(u,3) ~= X(v,3)
            reduce(u) = 1;
            reduce(v) = 1;
        end
        % ��������
        x = [X(u,1) X(v,1)];
        y = [X(u,2) X(v,2)];
        plot(x, y, '-b');
        hold on;
    end
    idx = find(reduce==1);
end

