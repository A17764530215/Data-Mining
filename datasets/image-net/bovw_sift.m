% ����ά��
k = 512;
% ����Dense SIFT����
[ discr, count, class ] = batch_dsift('./Images/', image_net(1:4,1));
% BOW����
disc = double(discr)';
[IDX, C] = kmeans(disc, k);
% BoVW���ݼ�
X = bovw(IDX, count, k);
Y = class;