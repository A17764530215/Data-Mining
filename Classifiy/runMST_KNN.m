images = '../images/CSVM/';

X = LR;

h = figure('Visible', 'on');
header = cell(3, 1);
% ����������ɢ��ͼ
title('MST_KNN');
xlabel('X1');
ylabel('X2');
SCATTER(X);
hold on;
header{1} = FRAME(h);
saveas(h, [images, 'SCATTER.png']);
% ������С������
start = 5;
mst = MST(X(:, 1:2), start);
% ������С������
[M, idx] = MST_PLOT(X, mst);
header{2} = FRAME(h);
saveas(h, [images, 'SCATTER_MST.png']);
% ������ص�
scatter(X(idx, 1), X(idx, 2), 24, 'ob');
hold on
header{3} = FRAME(h);
saveas(h, [images, 'SCATTER_MST_L0.png']);

% ����20�׼����½���
file = 'MST_KNN.gif';
nL = 18;
im = cell(nL, 1);
for L = 1 : nL
    title(['L', num2str(L), '�׽���']);
    IDX = MST_KNN(M, idx, L);
    scatter(X(IDX, 1), X(IDX, 2), 32, [0.3*L/nL 0.6  0.8*L/nL], 'filled');
    hold on;
    % ��������
    im{L} = FRAME(h);
end
close;

GIF([header; im], [images, 'SCATTER_MST_KNN.gif']);