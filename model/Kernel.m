function [ Y ] = Kernel(tstX, X, opts)
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
    [ m, ~ ] = size(X);
    [ n, ~ ] = size(tstX);
    Y = exp(-(repmat(sum(tstX.*tstX,2)',m,1)+repmat(sum(X.*X,2),1,n) - 2*X*tstX')/(2*p1^2));
    Y = Y';

end