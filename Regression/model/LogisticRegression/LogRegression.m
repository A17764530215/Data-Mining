function [  ] = LogRegression( X, Y, Optimizer, NumIter )
%LOGREGRESSION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if ismatrix(X) == 1
        [m, ~] = size(X);
    end
    % ������һ��
    e = ones(m, 1);
    X = [e X];
    % ��������С
    [m, n] = size(X);
    fprintf('size = [%d, %d]\n', m, n);
    % Logistic�ݶ��Ż�
    if Optimizer == 'SGA'
        W = SGA(X, Y, NumIter);
    else
        W = BGA(X, Y, NumIter);
    end
    % ��ͼ
    fg = figure(1);
    title('LR-BGA');
    xlabel('x1');
    ylabel('x2');
    % �������е�
    %scatter(X(:,2), X(:,3), 1, '*');
    %hold on;
    % ���������
    XP = X(Y(:,1)==1,:);
    scatter(XP(:,2), XP(:,3), 12, '+');
    hold on;
    % ���Ƹ����
    XN = X(Y(:,1)==0,:);
    scatter(XN(:,2), XN(:,3), 12, 'O');
    hold on;
    % �����������
    x = -3.0:0.1:3.0;
    y = (-W(1)-W(2)*x)/W(3);
    plot(x, y);
    % ����ͼƬ
    saveas(fg, ['../images/', 'LR-BGA.png']);
end

