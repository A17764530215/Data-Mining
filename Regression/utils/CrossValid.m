function [ Stats, Time ] = CrossValid( Learner, X, Y, k, ValInd, Params )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% k�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%  Learner    -ѧϰ�㷨
%        D    -���ݼ�
%        k    -k�۽�����֤
%   ValInd    -������֤����
% �����
%      MAE    -ƽ���������
%     RMSE    -���������
%  SSE/SST    -
%  SSR/SSE    -
%     Time    -ƽ��ѵ��ʱ��

    % ѵ��ʱ��
    Times = zeros(1, k);
    Stats = zeros(k, 1);
    % ʵ��ǽ���k��(������֤����)����k�ε�ƽ��ֵ��Ϊʵ����
    for i = 1 : k
        fprintf('CrossValid: %d', i);
        % �õ�ѵ���Ͳ��Լ�����
        test = (ValInd == i);
        train = ~test;
        % ѵ����Ԥ��
        [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
        % ��¼ʱ��
        yTest = Y(test,:);
        Times(1, i) = Time;
        Stats(i, 1) = mse(y-yTest, yTest, y);
        Stats(i, 2) = mae(y-yTest, yTest, y);
        Stats(i, 3) = sse(y-yTest, yTest, y);
        Stats(i, 4) = sae(y-yTest, yTest, y);
    end
end