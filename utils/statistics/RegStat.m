function [ Stat ] = RegStat(y, yTest)
%REGSTAT �˴���ʾ�йش˺�����ժҪ
% ͳ������
%   �˴���ʾ��ϸ˵��

    e = y - yTest;
    MAE = mean(abs(e));
    RMSE = sqrt(mean(e.^2));
    SSE = sum(e.^2);
    Y = mean(yTest);
    SST = sum((yTest-Y).^2);
    SSR = sum((y-Y).^2);
    SSET = SSE/SST;
    SSRT = SSR/SST;
    Stat = [ MAE, RMSE, SSET, SSRT ];
end