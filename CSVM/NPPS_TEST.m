images = '../images/CSVM/';

% X = LR(:,1:2);
% Y = LR(:,3);
[X, Y] = Sine(1600);

h = figure('Visible', 'on');

% ����������ɢ��ͼ
title('MST_KNN');
xlabel('X1');
ylabel('X2');
SCATTER([X Y]);
hold on;

% ���������ģʽѡ��
% idx = NPPS(X, Y, 16);
% Xn = X(idx,:);

% ���Һ�ģʽѡ��
Xn = NDP(X, Y, 24, 12, 12);

% ����ɢ��ͼ
scatter(Xn(:,1),Xn(:,2),24,'ob');
hold on

