images = '../images/CSVM/';

X = LR(:,1:2);
Y = LR(:,3);

h = figure('Visible', 'on');

% ����������ɢ��ͼ
title('MST_KNN');
xlabel('X1');
ylabel('X2');
SCATTER(LR);
hold on;

% ���������ģʽѡ��
idx = NPPS(X, Y, 15);

% ����ɢ��ͼ
Xn = X(Y(idx,1)==0,:);
scatter(Xn(:,1),Xn(:,2),32,'ob');
hold on;
Xp = X(Y(idx,1)==1,:);
scatter(Xp(:,1),Xp(:,2),32,'ob');
hold on;
