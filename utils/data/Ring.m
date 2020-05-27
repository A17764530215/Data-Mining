function [ D ] = Ring( n, m, r )
%RING �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    data = rand(n, 2)*[2*r 0;0 2*r];
    vecs = data - [r r];
    dists = sqrt(sum(vecs.*vecs, 2));
    label = sign(mod(floor(dists/(r/m)), 2) - 0.5);
    D = [data, label];
end