function [ d ] = GetBestParam(Params, Data, index, x, y, draw)
%GETBESTPARAM �˴���ʾ�йش˺�����ժҪ
% �õ���Ѳ���
%   �˴���ʾ��ϸ˵��

%% �õ�������
Result = CreateParams(Params);
for i = 1:length(Result)
    for j = 1: length(index)
        Result(i).(index{j}) = Data(i, j);
    end
end
[ Max, IDX ] = max(Data);
[ Min, ~ ] = min(Data);

%% �õ�����ֵ
X = Params.(x);
Y = Params.(y);
Nx = length(X);
Ny = length(Y);
count = Nx*Ny;
L = floor(IDX(1)/count)*count+1;
R = ceil(IDX(1)/count)*count;
try
    Z = reshape([Result(L:R).(index{1})]', Ny, Nx);
    if draw
        surf(X, Y, Z);
        xlabel(['\', x]);
        ylabel(y);
    end
catch
    fprintf(['error:', Params.ID]);
end

%% ���Ų���
d.BestParam = Result(IDX(1));
d.Max = Max;
d.Min = Min;
d.Result = Result;
d.Interval = L: R;
d.Z = Z;

end

