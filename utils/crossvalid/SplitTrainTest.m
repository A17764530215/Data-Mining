function [ DTrain, DTest ] = SplitTrainTest( D, k )
%SPLITTRAINTEST �˴���ʾ�йش˺�����ժҪ
% ����������ָ�ѵ�����Ͳ��Լ�
%   �˴���ʾ��ϸ˵��
% ������
%     D    -���ݼ�
%     k    -ѵ��������
% ���أ�
%    DTrain   -ѵ����
%     DTest   -���Լ�

    [m, ~] = size(D);
    n = ceil(m*k);
    indices = randperm(m);
    DTrain = D(indices(1:n), :);
    DTest = D(indices(n+1:m), :);
end