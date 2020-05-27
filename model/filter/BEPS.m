function [ Xr, Yr ] = BEPS( X, Y, kb, ke, lambda, gamma )
%BEPS �˴���ʾ�йش˺�����ժҪ
% Border-Edge Pattern Selection (BEPS)
%   �˴���ʾ��ϸ˵��
% ������
%    kb    -is the number of nearest neighbors for computing border patterns. 
%    ��    -is the ratio used for deciding border patterns. 
%    ke    -is the number of nearest neighbors for computing edge patterns. 
%    ��    -is the ratio for deciding edge patterns.
%

    [m, n] = size(X);
    % �õ�����
    D = DIST(X);
    %
    l = zeros(m, 1);
    for i = 1 : m
        knn = KNN(D, i, kb);
        % The edge patterns are selected by following equations. calculate l(x_i);
        v = zeros(kb, n);
        vn = zeros(1, n);
        for j = 1 : kb
            v(j) = X(knn(j)) - X(i);
            vn = vn + v(j)/norm(vj);
        end
        theta = zeros(kb);
        for j = 1 : kb
            theta(j) = v(j)*vn';
            if theta(j) > 0
                l(i) = l(i) + theta(j);
            end
        end
        l(i) = l(i)/k;
        % The border patterns are selected by Choi and Rockett��s method.
    end

end