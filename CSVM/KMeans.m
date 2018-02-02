function [ C, V ] = KMeans( X, k )
%KMEANS �˴���ʾ�йش˺�����ժҪ
% K��ֵ����
%   �˴���ʾ��ϸ˵��
% ������
%    X   -���ݼ�
%    k   -������
%    Y   -�����ǩ
%    V   -��������
% �����
%    C   -�ػ���
%    V   -��������

    % �õ����ݼ�ά��
    [m, ~] = size(X);
    % ��X�����ѡȡk��������Ϊ��ʼ��ֵ����
    vid = randperm(m, k);
    vx = X(vid, :);
    vy = (1:1:k)';
    % ����ÿһ������
    C = zeros(m, 1);
    % repeat
    updated = 1;
    while updated == 1
        for i = 1 : m
            % ����xi�����ֵ����vi�ľ���
            dv = repmat(X(i, :), k, 1) - vx;
            di = sqrt(sum(dv.*dv, 2));
            % ���ݾ�������ľ�ֵ����ȷ��xj�Ĵر��
            [~, yi] = min(di);
            % ������xj������Ӧ�Ĵ�
            C(i) = yi;
        end
        updated = 0;
        for j = 1 : k
            % �����¾�ֵ����
            uid = find(C==j);
            un = length(uid);
            ux = sum(X(uid, :), 1)/un;
            % ���ux!=vx�����¾�ֵ����
            if ux ~= vx(j, :)
                vx(j, :) = ux;
                % ��Ǿ�ֵ�����и���
                updated = 1;
            end
        end
    end
    V = [vx, vy];
end