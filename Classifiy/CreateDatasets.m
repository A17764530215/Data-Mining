datasets = '../datasets/artificial/';

% ���ݼ�
% Datasets = {
%     Sine(4000)
%     Grid(4000, 2, 2, 1)
%     Ring(4000, 2, 2)
% };

% ���ݼ�����
% DatasetNames = {
%     'Sine_4000', 'Grid_4000', 'Ring_4000'
% };

% �������ݼ�
file = [datasets, 'Datasets.mat'];
save(file, 'Datasets');