function [ X, Y, C ] = bovw( T, opts )
%BOVW 此处显示有关此函数的摘要
% Bag of Visual Word
%   此处显示详细说明
% 参数：
%       T    数据集
%    opts    参数

% 聚类数目
    k = opts.k;
    
% 特征集合
    [C1, C2] = cellcat(T, 1);
    [D1, D2] = cellcat(C1, 2);
% 原始数据集
    D = zscore(single(D1'));
% 聚类
    tic;
    [IDX, C] = kmeans(D, k);
    t = toc;
    fprintf('聚类时间：%.2f\n', t);
% 构建X和Y
    [ X ] = buildX(IDX, D2, k);
    [ Y ] = buildY(C2);
    [ X ] = sparse(X);
    
    function [ X ] = buildX(IDX, count, k)
        n = size(count, 1);
        X = zeros(n, k);
        u = 1;
        for i = 1 : n
            % 第i组u,v
            v = u + count(i) - 1;
            [ idx, feat ] = bow(IDX(u:v,:));
            X(i,idx) = feat;
            % 下一组
            u = u + count(i);
        end
    end

    function [ Y ] = buildY(count)
        n = size(count, 1);
        Y = zeros(sum(count), 1);
        u = 1;
        for i = 1 : n
            % 第i组u,v
            v = u + count(i) - 1;
            Y(u:v, 1) = i;
            u = u + count(i);
        end
    end

    function [ idx, feat ] = bow(IDX)
        tab = tabulate(IDX);
        cnt = tab(:,2)>0;
        idx = tab(cnt,1);
        feat = tab(cnt,3);
    end

end