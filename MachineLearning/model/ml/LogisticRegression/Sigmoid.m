function [ Y ] = Sigmoid( X )
%SIGMOID �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    Y = 1.0 ./ (1 + exp(-X));
end

