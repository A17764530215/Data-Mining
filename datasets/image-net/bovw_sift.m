% ����Dense SIFT����
% [ discr, class ] = batch_dsift('./Images/', image_net(1:4,1));
save 'dense_sift.mat' 'discr' 'count';
% BOW����
load 'dense_sift.mat';
disc = double(discr)';
k = 1000;
[IDX, C] = kmeans(disc, k);
% BoVW���ݼ�
X = bovw(IDX, count, k);