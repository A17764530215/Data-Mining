function [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y, yTest)
%STATISTICS �˴���ʾ�йش˺�����ժҪ
% ͳ������
%   �˴���ʾ��ϸ˵��

    y_bar = mean(yTest);
    E = yTest-y;
    E2 = E.^2;
    MAE = mean(abs(E));
    RMSE = sqrt(mean(E2));
    SSE = sum(E2);
    SST = sum((yTest-y_bar).^2);
    SSR = sum((y-y_bar).^2);
end
