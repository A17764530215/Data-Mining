function [ Output, Time ] = CrossValid( Learner, X, Y, Kfold, ValInd, Params, opts )
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

%     Stats = { 'MSE', 'MAE', 'SSE', 'SAE' };
    Funcs = { @mse, @mae, @sse, @sae };
    
    % ѵ��ʱ��
    Times = zeros(1, Kfold);
    Stats = zeros(Kfold, 4);
    % ʵ��ǽ���k��(������֤����)����k�ε�ƽ��ֵ��Ϊʵ����
    for i = 1 : Kfold
        fprintf('CrossValid: %d', i);
        % �õ�ѵ���Ͳ��Լ�����
        test = (ValInd == i);
        train = ~test;
        % ѵ����Ԥ��
        opts.Params = Params;
        [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), opts);
        % ��¼ʱ��
        Times(1, i) = Time;
        % ͳ��ָ��
        yTest = Y(test,:);
        for j = 1 : 4
            Stats(i, j) = Funcs{j}(y-yTest, yTest, y);
        end
    end
    Output = mean(Stats);
    Time = mean(Times);
end