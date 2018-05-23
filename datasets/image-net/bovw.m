function [ X ] = bovw( IDX, count, k )
%BOVW �˴���ʾ�йش˺�����ժҪ
% Bag of Visual Word
%   �˴���ʾ��ϸ˵��

    n = size(count, 1);
    X = sparse(n, k);
    u = 1;
    for i = 1 : n
        % ��i��u,v
        v = u + count(i) - 1;
        tab = tabulate(IDX(u:v,:));
        cnt = tab(:,2)>0;
        idx = tab(cnt,1);
        fre = tab(cnt,3);
        X(i,idx) = fre;
        % ��һ��
        u = u + count(i);
    end
end

