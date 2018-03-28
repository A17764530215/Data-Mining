function [ S ] = BiKMeans( X, m, k )
%BIKMEANS �˴���ʾ�йش˺�����ժҪ
% ����k��ֵ����
%   �˴���ʾ��ϸ˵��
% ������
%    X    -���ݼ�
%    m    -���ִ���
%    k    -Ŀ�����
% �����
%    S    -�ؼ�
%

    [n, ~] = size(X);
    % Step 1: ��ʼ���ؼ�S��ֻ����һ�����������Ĵأ�������k'��ʼ��Ϊ1��
    S = ones(n, 1);
    k1 = 1;
    while k1 < k
        % Step 2: ��S��ȡ��һ�����Ĵ�Ni��
        hist = histc(S, 1: k1);
        [~, ix] = max(hist);
        Ni = X(S==ix, :);
        % ���Ŵػ���
        BestC = zeros(length(Ni), 1);
        SSE = Inf;
        for i = 1 : m
            % Step 3: ʹ��k-��ֵ�����㷨�Դ�Ni����m�ζ��־��������
            [C, V] = KMeans(Ni, 2);
            % Step 4: �ֱ������m���Ӵص���SSE��С��
            sse = 0;
            for j = 1 : 2
                NV = Ni(C==j, :) - V(j);
                EV = sum(NV.*NV, 2);
                sse = sse + sum(EV);
            end
            % Step 4: �ҳ���SSE��С�Ĵػ��֣�
            if sse < SSE
                SSE = sse;
                BestC = C;
            end
        end
        % Step 4: ��������С��SSE��һ���Ӵ���ӵ�S�У�
        fprintf('Split: C%d -> C%d + C%d\n', ix, k1 + 1, ix);
        BestC(BestC==2) = k1 + 1; % ����һ������Ϊk1 + 1��
        BestC(BestC==1) = ix; % ��һ���ر���ԭʼ��ţ�
        S(S==ix) = BestC; % S������ix��ָ�Ϊ�´�
        % Step 4: ִ��k'++������
        k1 = k1 + 1;
    % Step 5: ���k'=k���㷨�����������ظ�Step 2 - Step 5��
    end
end