function [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, X, Y, ValInd, k )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% k�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%         Clf    -������
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
        % ��ѵ������ѵ��
        [Clf, Time] = Clf.Fit(X(train,:), Y(train,:));
        % �ڲ��Լ��ϲ���
        [yTest] = Clf.Predict(X(test,:));
        % ��������
        classperf(cp, yTest, test);
        % ��¼ʱ��
        Times(1, i) = Time;
    end
    Accuracy = cp.CorrectRate;
    Precision = cp.PositivePredictiveValue;
    Recall = cp.Sensitivity;
    Time = mean(Times);
end