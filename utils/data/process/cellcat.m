function [ cout, count ] = cellcat(cin, dim)
%CELLCAT 此处显示有关此函数的摘要
%   此处显示详细说明
    n = size(cin, 1);
    cout = [ ];
    count = zeros(n, 1);
    for i = 1 : n
        cout = cat(dim, cout, cin{i});
        count(i,1) = size(cin{i}, dim);
    end
end
