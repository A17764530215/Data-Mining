function [ W ] = SGA( X, Y, NumIter )
%SGA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if ismatrix(X) == 1
        [m, n] = size(X);
    end
%    alpha = 0.01;
    weights = ones(n);
    for j = 1 : NumIter
        for i = 1 : m
            alpha = 4 / (1.0 + j + i) + 0.01;
            rand_index = randperm(m, 1);
            h = Sigmoid(sum(X(rand_index) * weights));
            e = Y(rand_index) - h;
            weights = weights + alpha*e*X(rand_index);
        end
    end
    W = weights;
end

