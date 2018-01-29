images = '../images/CSVM/';

% ȡ��һ�����ݼ�ǰ400��������ʵ��
D = Datasets{1};
D = D(1:400,:);
% ��������
C = -3:1:3;
Sigma = 2:1:6;
% ��������
[ Output ] = GridSearch( D, 10, 2.^C, 2.^Sigma );

% ������ʽ
styles = {
    '-r', '-g', '-b', '-y', '-c'
};
% ��������ͼ
h = figure();
bar(Output);

save runGridSearch.m Output
saveas(h, [images, 'runGridSearch.png']);