function [ C, V, Rho, Delta, Gamma, idx, DeltaTree, Halo, nCore, nHalo ] = DP( X, k )
%DP �˴���ʾ�йش˺�����ժҪ
% Density Peaks
%   �˴���ʾ��ϸ˵��
% ������
%          X    -���ݼ�
%          k    -����
% ����ֵ��
%          C    -cluster assignment
%          V    -������
%        Rho    -������ֲ��ܶ�
%      Delta    -��������������Ľϸ��ܶȵ�ľֲ��ܶ�
%      Gamma    -Rho*Delta
%        idx    -��������
%  DeltaTree    -��������������Ľϸ��ܶȵ�
%       Halo    -��Halo
%      nCore    -�غ���������
%      nHalo    -�ر�Ե������

    % ��ʼ���ػ���
    [m, ~] = size(X);
    C = zeros(m, 1);
    % ����������
    d = DIST(X);
    % ѡȡǰ2%����Ϊdc
    du = triu(d); % ȡ������
    sdu = sort(du(:)); % ��������
    sdu = sdu(sdu > 0); % ����0�ľ���
    l = m*(m-1)/2;
    rate = 0.02;
    dc = sdu(round(l*rate));
    % Basically, rho[i] is equal to the number of points that are closer than dc to point i.
    Rho = zeros(m, 1);
    for i = 1 : m
        j = setdiff(1 : m, i);
        di = d(i, j);
        % 1. Cut-off.
        Rho(i) = sum(di<dc);
        % 2. Guassian kernel.
        Rho(i) = sum(exp(-(di.*di)/(dc*dc)));
    end
    [~, rho_idx] = sort(Rho, 'descend');
    % delta[i] is measured by computing the minimum distance between the
    % point i and any other point with higher density
    Delta = zeros(m, 1);
    DeltaTree = zeros(m, 1);
    % Build Delta-Tree
    Peak = rho_idx(1);
    Delta(Peak) = max(d(Peak, :));
    DeltaTree(Peak) = Peak;
    for i = 2 : m
        % cluster center
        Peak = rho_idx(i);
        % find the nearest neighbour from the points with higher density 
        higher = rho_idx(1:i-1);
        [dist, idx] = min(d(Peak, higher));
        Delta(Peak) = dist;
        DeltaTree(Peak) = higher(idx);
    end
    % A hint for choosing the number of centers is provided by 
    % the plot of gamma = rho*delta sorted in decreasing order
    Gamma = Rho.*Delta;
    [ ~, gamma_idx ] = sort(Gamma, 'descend');
    idx = gamma_idx(1:k);
    % Hence, as anticipated, the only points of high delta and relatively high ��
    % are the cluster centers.
    DeltaTree(idx) = idx;
    V = X(idx);
    % assignation
    C(idx) = (1:k).';
    for i = 1 : m
        u = rho_idx(i);
        % assign cluster label
        if C(u) == 0
            C(u) = C(DeltaTree(u));
        end
    end
    %halo
    Halo = C;
    if k > 1
        border_rho = zeros(k, 1);
        for i = 1 : m - 1
            u = C(i); % �õ�i�Ĵػ���
            for j = i + 1 : m
                v = C(j); % �õ�j�Ĵػ���
                % ����С��dc�������i,j
                if u~=v && d(i,j)<=dc
                    % ����������ܶȵ�ƽ��ֵ
                    rho_aver = (Rho(i) + Rho(j))/2.0;
                    % �ҵ�C(i)���߽��ܶ����ƽ��ֵ
                    if (rho_aver > border_rho(u)) 
                        border_rho(u) = rho_aver;
                    end
                    % �ҵ�C(j)���߽��ܶ����ƽ��ֵ
                    if (rho_aver > border_rho(v)) 
                        border_rho(v) = rho_aver;
                    end
                end
            end
        end
        % ��ÿһ������
        for i = 1 : m
            % ����ܶ�С����������Ե�ܶ�
            if Rho(i) < border_rho(C(i))
                % ��i����halo
                Halo(i) = 0;
            end
        end
    end
    % core and halo statistics
    for i = 1 : k
        nCore = 0;
        nHalo = 0;
        for j = 1 : m
            if C(j) == i
                nCore = nCore + 1;
            end
            if Halo(j) == i
                nHalo = nHalo + 1;
            end
        end
    end
end