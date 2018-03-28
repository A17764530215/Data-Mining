function [ D ] = Normalize( Data, LabelColumn )
%NOMALIZE �˴���ʾ�йش˺�����ժҪ
% ��һ������׼������
%   �˴���ʾ��ϸ˵��

    [X, Y] = SplitDataLabel(Data, LabelColumn);
    [m, n] = size(X);
    Xn = zeros(m, n);
    for i = 1 : n
        Xi = X(:, i);
        Xn(:, i) = (Xi - mean(Xi))./std(Xi);
        % Xn(:, i) = mapminmax(Xi);
    end
    D = [Xn, Y];
end

