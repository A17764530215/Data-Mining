function [ Xn, Yn ] = NDP_PART( X, Y, k, th )
%CSUM �˴���ʾ�йش˺�����ժҪ
% Cosine Sum Sample Selection Part
% 
% ������
%   X   -���ݼ�
%   Y   -��ǩ��
%   k   -������
%   th  -���Һ���ֵ
% 
%   �˴���ʾ��ϸ˵��
    % �õ�ά��
    [m, ~] = size(X);
    % ɸѡ����
    samples = zeros(m, 1);
    % �õ�����
    M = DIST(X);
    % Step 1: Solve the problem of k-nearest neighbors on D;
    for x = 1 : m
        knn = KNN(M, x, k);
        % Calculate cosine sum according to formula (6) or formula (8);
        % Definition 3-1(mass center).
        xk = mean(X(knn, :));
        % Definition 3-2(sample-neighbor angle).
        x0k = X(x,:) - xk; % x0 - xk, 1*n ����
        x0i = repmat(X(x,:), k, 1) - X(knn,:); % x0 - xi kn * n
        % Definition 3-3(cosine sum).
        csum = 0;
        for i = 1 : k
            B = x0i(i,:);
            cosine = (x0k*B')/(norm(x0k)*norm(B));
            csum = csum + cosine;
        end
        % Step 2: p reserve the samples, whose cosine sum is greater than th;
        if csum > th
            samples(x) = 1;
        end
    end    
    idx = find(samples==1);
    Xn = X(idx,:); Yn = Y(idx,:);
end