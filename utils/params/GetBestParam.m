function [ d ] = GetBestParam(Params, Data, index, x, y)
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

%% ���Ų���
d.BestParam = Result(IDX(1));
d.Max = Max;
d.Min = Min;
d.Result = Result;
d.Interval = L: R;
d.Z = Z;

end

