function [ Accuracy, Precision, Recall, Time ] = CrossValid( Learner, X, Y, ValInd, k, opts )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% k�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%     Learner    -ѧϰ�㷨
%           D    -���ݼ�
%      ValInd    -������֤����
%           k    -k�۽�����֤
% �����
%    Accuracy    -��ȷ��
%   Precision    -׼ȷ��
%      Recall    -�ٻ���
%        Time    -ƽ��ѵ��ʱ��

    % ѵ��ʱ��
    Times = zeros(1, k);
    % ����Ч��
    cp = classperf(Y);
    % ʵ��ǽ���k��(������֤����)����k�ε�ƽ��ֵ��Ϊʵ����
    for i = 1 : k
        fprintf('CrossValid: %d', i);
        % �õ�ѵ���Ͳ��Լ�����
        test = (ValInd == i);
        train = ~test;
        % ѵ����Ԥ��
        [ yTest, Time ] = Learner(X(train,:), Y(train,:), X(test,:), opts);
        % ����Ч��
        classperf(cp, yTest, test);
        % ��¼ʱ��
        Times(1, i) = Time;
    end
    Accuracy = cp.CorrectRate;
    Precision = cp.PositivePredictiveValue;
    Recall = cp.Sensitivity;
    Time = mean(Times);
end