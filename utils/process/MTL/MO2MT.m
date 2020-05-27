function [ Xr, Yr ] = MO2MT( X, Y )
%MO2MT 此处显示有关此函数的摘要
% Multi-Output 2 Multi-Task
%   此处显示详细说明

    [m, n] = size(Y);
    Xr = repmat(X, n, 1);
    Xr = mat2cell(Xr, ones(n, 1)*m);
    Yr = mat2cell(Y, m, ones(n, 1))';
end