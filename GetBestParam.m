function [ BestParam, Accuracy, L, R ] = GetBestParam(CParams, CVStat, x, y)
%GETBESTPARAM �˴���ʾ�йش˺�����ժҪ
% �õ���Ѳ���
%   �˴���ʾ��ϸ˵��

%% �õ�����
IParams = CreateParams(CParams);
%%
Stat = mean(CVStat, 3);
for i = 1:length(IParams)
    IParams(i).Accuracy = Stat(i, 1);
    IParams(i).Std = Stat(i, 2);
end
[Accuracy, IDX] = max(Stat);
%% �õ�����ֵ
X = CParams.(x);
Y = CParams.(y);
Nx = length(X);
Ny = length(Y);
count = Nx*Ny;
L = floor(IDX(1)/count)*count+1;
R = ceil(IDX(1)/count)*count;
Z = reshape([IParams(L:R).Accuracy]', Ny, Nx);
surf(X, Y, Z);

BestParam = IParams(IDX(1));
end

