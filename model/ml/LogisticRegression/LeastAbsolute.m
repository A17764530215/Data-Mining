function [ z, history ] = LeastAbsolute( A, b )
%LEASTABSOLUTE �˴���ʾ�йش˺�����ժҪ
% min  ||z||_1
% s.t. Ax - z = b
%   �˴���ʾ��ϸ˵��

    MAX_ITER = 400;
    [~, n] = size(A);
%     x = zeros(n, 1);
    z = zeros(n, 1);
    u = zeros(n, 1);
    AtA = (A'*A);
    for k = 1 : MAX_ITER
        % update x
        x = AtA\A'*(b+z-u);
        % update z
        z = Shrinkage(A*x-b+u, 1);
        % update y
        u = u + (A*x-z-b);
        % history
        history.x(k, :) = x;
        history.z(k, :) = z;
    end

%% Soft Thresholding
    function [ Z ] = Shrinkage(X, T)
        Z = sign(X).*max(abs(X)-T, 0);
    end

end

