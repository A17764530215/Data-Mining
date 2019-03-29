function [ BestParam, Accuracy, Result, L, R, Z ] = GetBestParam(CParams, Stat, INDICES, x, y)
%GETBESTPARAM 此处显示有关此函数的摘要
% 得到最佳参数
%   此处显示详细说明

%% 得到参数表
Result = CreateParams(CParams);
for i = 1:length(Result)
    for j = 1: length(INDICES)
        Result(i).(INDICES{j}) = Stat(i, j);
    end
end
[Accuracy, IDX] = max(Stat);
%% 得到参数值
X = CParams.(x);
Y = CParams.(y);
Nx = length(X);
Ny = length(Y);
count = Nx*Ny;
L = floor(IDX(1)/count)*count+1;
R = ceil(IDX(1)/count)*count;
Z = reshape([Result(L:R).(INDICES{1})]', Ny, Nx);
surf(X, Y, Z);
%% 最优参数
BestParam = Result(IDX(1));
end

