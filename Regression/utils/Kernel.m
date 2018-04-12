function [ Y ] = Kernel(U, V, opts)
%KERNEL �˴���ʾ�йش����ժҪ
% �˺���
%   �˴���ʾ��ϸ˵��
% ������
%     U    -����U
%     V    -����V
%  opts    -�˺�������

    % Parse opts
    p1 = opts.p1;
    % Kernel
    Y = exp(-(repmat(sum(U.*U,2)',m,1)+repmat(sum(V.*V,2),1,m1) - 2*V*U')/(2*p1^2));
    Y = Y';

end