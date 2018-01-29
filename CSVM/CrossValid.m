function [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D, n, C, Sigma )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% n�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%      D    -���ݼ�
%      n    -n�۽�����֤
%      C    -����C
%  Sigma    -������

    % ��ʼ������������
    clf = CSVM(C, Sigma);
    % �ָ�������ǩ
    [X, Y] = SplitDataLabel(D);
    Y(Y==-1) = 0;
    % ������֤
    indices = crossvalind('Kfold', Y, n);
    cp = classperf(Y);
    % ʵ��ǽ���n��(������֤����)����n�ε�ƽ��ֵ��Ϊʵ����
    for i = 1 : n
        % �õ�ѵ���Ͳ��Լ�����
        test = (indices == i);
        train = ~test;
        % ��ѵ������ѵ��
        [clf, ~] = clf.Fit(X(train,:), Y(train,:));
        % �ڲ��Լ��ϲ���
        [clf, y] = clf.Predict(X(test,:));
        % ��������
        classperf(cp, y, test);
    end
    Recall = cp.Sensitivity;
    Precision = cp.PositivePredictiveValue;
    Accuracy = cp.CorrectRate;
    FAR = cp.Specificity;
    FDR = 1 - cp.Specificity;
end