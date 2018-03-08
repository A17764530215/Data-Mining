function [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, D, k )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% n�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%    Clf    -������
%      D    -���ݼ�
%      k    -k�۽�����֤

    fprintf('CrossValid: %d fold, CSVM(%4.6f, %4.6f)\n', k);
    % �ָ�������ǩ
    [X, Y] = SplitDataLabel(D);
    Y(Y==-1) = 0;
    % ��¼ʱ��
    Times = zeros(1, k);
    % ������֤
    indices = crossvalind('Kfold', Y, k);
    cp = classperf(Y);
    % ʵ��ǽ���k��(������֤����)����k�ε�ƽ��ֵ��Ϊʵ����
    for i = 1 : k
        fprintf('CrossValid:%d\n', i);
        % �õ�ѵ���Ͳ��Լ�����
        test = (indices == i);
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