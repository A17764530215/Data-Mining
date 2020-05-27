function [ Xn, Yn ] = FNSSS( X, Y, r, k )
%FNSSS �˴���ʾ�йش˺�����ժҪ
% Fixed Neighborhood Sphere Sample Selection (FNSSS)
%   �˴���ʾ��ϸ˵��
% ������
%   X    -����
%   Y    -��ǩ
%   r    -������뾶
%   k    -��������

    [m, n] = size(X);
    % ����r��ÿһά�����仮�ֳ�����
    mins = min(X);
    maxs = max(X);
    ranges = ceil((maxs - mins)/r);
    % ��ÿһ���������з���
    blocks = ceil((X - mins)/r);
    % ɸѡ����
    samples = zeros(m, 1);
    % ��n��ά��ɸѡ�ڽ�block�������õ�cells����
    cells = cell(n, 1);
    for i = 1 : m
        % �õ�����i����block
        b = blocks(i, :);
        for j = 1 : n
            index = b(j);
            if index == 1
                % ��jά�������Ե
                cells{j} = find(blocks(:, j)==1 | blocks(:, j)==2);
            elseif b(j) == ranges(j)
                % ��jά�����ұ�Ե
                cells{j} = find(blocks(:, j)==index | blocks(:, j)==(index-1));
            else
                % ��jά���м�����
                cells{j} = find(blocks(:, j)==(index-1) | blocks(:, j)==index | blocks(:, j)==(index+1));
            end
        end
        % �õ�ɸѡ����
        for j = 2 : n
            cells{1} = intersect(cells{1}, cells{j});
        end
        % ɸѡ�ڽ���ͬ���
        Ys = find(Y==Y(i));
        idx = intersect(Ys, cells{1});
        % step 2: count the neighbors in the neighborhood sphere;
        vecs = X(idx, :)-X(i, :);
        dists = sqrt(sum(vecs.*vecs, 2));
        samples(i, :) = length(find(dists<=r/3));
    end
    % step 3: sort the samples according to the number of the neighbors by ascending order;
    [~, IX] = sort(samples, 'ascend');
    % step 4: reserving the l samples to represent the training set.
    Xn = X(IX(1:k), :); Yn = Y(IX(1:k), :);
end