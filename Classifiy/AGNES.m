function [ C ] = AGNES( X, k, d )
%AGNES �˴���ʾ�йش˺�����ժҪ
% AGNES ��ξ����㷨
%   �˴���ʾ��ϸ˵��
% ������
%    X   -���ݼ�
%    k   -�������
% �����
%    C   -�ػ���
%

    [m, ~] = size(X);
    % ��ʼ�������������
    C = (1:m)';
    % ��ʼ���������
    M = DIST(X);
    D = M;
    % ���õ�ǰ����ظ���
    q = m;
    while q > k
        % �ҵ��������������
        dist = min(M(M~=0));
        idx = find(M==dist);
        [r, c] = ind2sub(size(M), idx(1));
        i = min([r c]);
        j = max([r c]);
        % �ϲ�Ci��Cj
        C(C==j) = i;
        % �������C_{j}���±��ΪC_{j-1}
        C(C>j) = C(C>j)-1;
        % ɾ���������ĵ�j�����j��
        M(j, :) = [];
        M(:, j) = [];
        q = q - 1;
        % ���¼����i����j�ľ���
        for j = 1 : q
            % �õ���i���j�ľ���
            Mij = D(C==i, C==j);
            switch(d)
                case {'min'}
                % 1. �����ӷ�
                M(i, j) = min(Mij(:));
                case {'max'}
                % 2. ȫ���ӷ�
                M(i, j) = max(Mij(:));
                case {'avg'}
                % 3. ƽ�����ӷ�
                M(i, j) = mean(Mij(:));
            end
            M(j, i) = M(i, j);
        end
    end
end