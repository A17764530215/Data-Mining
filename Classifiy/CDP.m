function [ C, V, Rho, Delta, Tau, Gamma, idx, DeltaTree ] = CDP( X, Y, k, oracle )
%CDP �˴���ʾ�йش˺�����ժҪ
% Comparative Density Peaks
%   �˴���ʾ��ϸ˵��
% ������
%          X    -���ݼ�
%          Y    -��ǩ��
%          k    -����
%     oracle    -���� Oracle Tree
% ����ֵ��
%          C    -cluster assignment
%          V    -������
%        Rho    -������ֲ��ܶ�
%      Delta    -��������������Ľϸ��ܶȵ�ľֲ��ܶ�
%        Tau    -��������������Ľϵ��ܶȵ�ľֲ��ܶ�
%      Gamma    -Rho*Tau
%        idx    -��������
%  DeltaTree    -��������������Ľϸ��ܶȵ�

    % ��ʼ���ػ��ֺ;�������
    [m, ~] = size(X);
    C = zeros(m, 1);
    % ����������
    d = DIST(X);
    % 1. Construct the mKNN Graph.    
    [ KnnIdx, ~, KnnMatrix ] = mKNN( X, round(0.01*m) );
    % ѡȡǰ2%����Ϊdc
    du = triu(d); % ȡ������
    sdu = sort(du(:)); % ��������
    sdu = sdu(sdu > 0); % ����0�ľ���
    l = m*(m-1)/2;
    rate = 0.02;
    dc = sdu(round(l*rate));
    % 2. For each point i, calculate Rho[i] using (8).
    Rho = zeros(m, 1);
    for i = 1 : m
        di = d(i, KnnIdx(i, :));
        Rho(i) = sum(exp(-(di.*di)/(dc*dc)));
    end
    [~, rho_idx] = sort(Rho, 'descend');
    Rho = mapminmax(Rho, 0, 1);
    % 3. For each point i, find its nearest neighbour with a higher density
    % Delta[i] and calculate the geodesic distance delta[i] according to
    % (9) or (10) and also tau.
    Delta = zeros(m, 1);
    DeltaTree = zeros(m, 1);
    % calculate delta and Delta.
    Peak = rho_idx(1);
    Delta(Peak) = max(d(Peak, :));
    DeltaTree(Peak) = Peak;
    for i = 2 : m
        % cluster center
        Peak = rho_idx(i);
        % find the nearest neighbour from the points with higher density.
        higher = rho_idx(1 : i - 1);
        % Given all Rho[i] values, we can have the perfect clustering
        % result by assigning each Delta[i] as the nearest point of the
        % same class as that of i but stiil having a higher density, unless
        % i has the highest density in its class.
        if oracle == true
            class_i = find(Y==Y(i));
            higher = intersect(higher, class_i);
        end
        % calculate delta and Delta.
        [ dist, idx ] = GeodesicLines( d, KnnMatrix, Peak, higher );
        Delta(Peak) = dist;
        DeltaTree(Peak) = idx;
    end
    % Specifically, after every delta[i] value is calculated, we adjust the
    % delta[i] value of the point with the highest density to the sum of 
    % the largest delta value of other points and a very small number.
    epsilon = 0.1;
    Delta(rho_idx(1)) = Delta(rho_idx(2)) + epsilon;
    % calculate tau.
    Foot = rho_idx(m);
    Tau = zeros(m, 1);
    Tau(Foot) = Delta(Foot);
    for i = 1 : m - 1
        % cluster center
        Peak = rho_idx(i);
        % find the nearest neighbour from the points with a lower density
        lower = rho_idx(i + 1:m);
        % calculate tau.
        [ dist, ~ ] = GeodesicLines( d, KnnMatrix, Peak, lower );
        Tau(Peak) = dist;
    end
    % The normalization is to avoid unfair comparisons by scaling the 
    % points in the non-negative quadrant into the range of 0 to 1 in each
    % dimension.
    Delta = mapminmax(Delta, 0, 1);
    Tau = mapminmax(Tau, 0, 1);
    % 4. For each point i, calculate the quantity theta[i] in (6).
    Theta = Delta - Tau;
    % A hint for choosing the number of centers is provided by 
    % the plot of gamma = rho*theta sorted in decreasing order
    Gamma = Rho.*Theta;
    [ ~, gamma_idx ] = sort(Gamma, 'descend');
    % 5. Automatically select a predefined number of points with the
    % largest gamma values as cluster centers.
    idx = gamma_idx(1:k);
    DeltaTree(idx) = idx;
    % Hence, as anticipated, the only points of high delta and relatively 
    % high rho are the cluster centers.
    V = X(idx);
    C(idx) = (1:k).';
    % 6. Assign each non-center point to the same cluster to which its
    % Delta[i] point belongs.
    for i = 1 : m
        u = rho_idx(i);
        % assign cluster label
        if C(u) == 0
            C(u) = C(DeltaTree(u));
        end
    end    
end