function [ Xn, Yn ] = NSCP( X, Y, k )
%NSCP �˴���ʾ�йش˺�����ժҪ
% Non-Stable Cut Point Sample Selection [Decision Tree]
%   �˴���ʾ��ϸ˵��
% ������
%      X    -����
%      Y    -��ǩ
%      k    -ѡ�����

    [m, n] = size(X);
%     class = unique(Y);
%     nclass = length(class);
%     GATS = zeros(m-1, 1);
    % ɸѡ����
    samples = zeros(m, n);
    for i = 1 : n
        % ��i�����ϰ������������
        [~, IX] = sort(X(:, i), 'ascend');        
        % ��ÿһ������������б���
%         for j = 1 : m-1
%             S1 = IX(1:j); S2 = IX(j+1:m);            
%             P1 = 0; P2 = 0;
%             for c = 1 : nclass
%                 P1 = P1 + NSCP_Convex(length(find(Y(S1)==class(c)))/j);
%                 P2 = P2 + NSCP_Convex(length(find(Y(S2)==class(c)))/(m-j));
%             end
%             GATS(j) = j/m * P1 + (m-j)/m * P2;
%         end
        % stable point
        for j = 1 : m-1
            u = IX(j); v = IX(j+1);
            if Y(u) == Y(v)
                samples(u, i) = 0;
                samples(v, i) = 0;
            end
        end
        % non-stable point
        for j = 1 : m-1
            u = IX(j); v = IX(j+1);
            if Y(u) ~= Y(v)
                samples(u, i) = 1;
                samples(v, i) = 1;
            end
        end
        % �ҵ����ȶ��ָ�����ڵ���Сֵ
%         [Min, ~] = min(GATS);
        % �ҵ������Сֵ����������ȶ��ָ��
%         NSCP = find(GATS == Min <= 0.000001);
        % ���ȶ��ָ�����һ���ָ�㣬Ҳ�ǲ��ȶ���
%         samples(IX(NSCP), i) = 1;
%         samples(IX(NSCP+1), i) = 1;
    end
    % ���㲻�ȶ�ָ��
    samples(:, 1) = sum(samples, 2);
    idx = find(samples(:,1) > k);
    % �õ�Լ��������ݼ�
    Xn = X(idx, :); Yn = Y(idx, :);
end
