function [ D ] = Sine( n )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    data = rand(n, 2)*[4*pi 0;0 4];
    data(:,2) = data(:,2) - 2;
    label = sign(data(:,2) - sin(data(:,1)));
    D = [data, label];
end

