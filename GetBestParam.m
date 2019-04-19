function [ d ] = GetBestParam(Params, Data, index, x, y)
%GETBESTPARAM 此处显示有关此函数的摘要
% 得到最佳参数
%   此处显示详细说明

%% 得到参数表
Result = CreateParams(Params);
for i = 1:length(Result)
    for j = 1: length(index)
        Result(i).(index{j}) = Data(i, j);
    end
end
[ Max, IDX ] = max(Data);
[ Min, ~ ] = min(Data);

%% 得到参数值
X = Params.(replace(x,'\',''));
Y = Params.(replace(y,'\',''));
Nx = length(X);
Ny = length(Y);
count = Nx*Ny;
L = mod(IDX(1)-mod(IDX(1), count)+1, count);
R = L+count - 1;
try
    Z = reshape([Result(L:R).(index{1})]', Ny, Nx);
catch
    fprintf(['error:', Params.ID]);
end

%% 最优参数
d.BestParam = Result(IDX(1));
d.Max = Max;
d.Min = Min;
d.Result = Result;
d.Interval = L: R;
d.Z = Z;

end

