function [ data, label ] = Grid( n, u, v, r )
%GRID �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    data = rand(n, 2)*[u 0;0 v];
    xs = mod(ceil(data(:,1)/r),2)==0;
    ys = mod(ceil(data(:,2)/r),2)==0;
    label = sign(xor(xs, ys) - 0.5);
end

