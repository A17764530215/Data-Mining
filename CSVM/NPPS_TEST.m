images = '../images/CSVM/';

% X = LR(:,1:2);
% Y = LR(:,3);
[X, Y] = Sine(6000);
% [X, Y] = Grid(6000, 2, 2, 1);
% [X, Y] = Nine();
% [X, Y] = Ring(4000, 2, 2);

% ����������ɢ��ͼ
h = figure('Visible', 'on');
% subplot(2,2,1);
% title('Subplot 1: Grid')
% xlabel('X1');
% ylabel('X2');
SCATTER([X Y]);
hold on;

% ���������ģʽѡ��
% [Xn, Yn] = NPPS(X, Y, 16);
% subplot(2,2,2);
% title('Subplot 2: NPPS')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% ���Һ�ģʽѡ��
% [Xn, Yn] = NDP(X, Y, 24, 12, 12);
% subplot(2,2,3);
% title('Subplot 3: NDP')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% �̶�����������ѡ��
% [Xn, Yn] = FNSSS(X, Y, 1, 1500);
% subplot(2,2,4);
% title('Subplot 4: FNSSS')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% ���ȶ��ָ������ѡ��
% [Xn, Yn] = NSCP(X, Y, 1);

% ���ھ��������ѡ�񷽷�
[Xn, Yn] = DSSM(X, Y, 1000);

% ����k���ڵ�����ѡ��
% [Xn, Yn] = KSSM(X, Y, 5);

% ����ɢ��ͼ
% h = figure('Visible', 'on');
scatter(Xn(:,1), Xn(:,2), 24, 'ob');
hold on
saveas(h, [images, 'DSSM_Sine.png']);