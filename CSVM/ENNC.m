function [ chains ] = ENNC( X, Y, k, alpha, beta )
%ENNC �˴���ʾ�йش˺�����ժҪ
%   Extended Nearest Neighbor Chain (ENNC)
%   alpha    -������������ 
%   beta     -������������ M[1,2] <= beta * M[0,1]
%   �˴���ʾ��ϸ˵��
    % �õ�ά��
    [m, ~] = size(X);
    % �õ�����
    M = DIST(X);
    % ɸѡ����
%     samples = zeros(m, 1);
    % ��ÿһ������x���õ�ENNC
    chains = cell(m, 1);
    vis = zeros(m);
    for x = 1 : m
        nc = KNN_D(Y, M, x, k);
        % ���û�в�ͬ��Ľ���
        if ISEMPTY(nc)
            % ����Զ�����ƽ�棬��Ϊ-1
            vis(x) = -1;
            % �������Ϊ��
            chains{x} = [];
        else            
            % ������չ�������
            j0 = x;
            j1 = nc(1);
            nc = KNN_D(Y, M, j1, k);
            % ���j1��������ڲ�Ϊ��
            chain = j0;
            while ISEMPTY(nc) == 0
                % Property 1; alpha = 3*beta
                if M(j0, j1) > alpha*M(j1,nc(1))
                    % j0Զ�����ƽ��
                    vis(j0) = -1;
                end
                % �����ĺ����������˳�; beta < 1
                % Property 2
                if beta * M(j0, j1) < M(j1, nc(1))
                    nc = KNN_D(Y, M, j1, k);
                    if ISEMPTY(nc) == 0
                        chain = [chain j1];                            
                        j0 = j1;
                        j1 = nc(1);
                        nc = KNN_D(Y, M, j1, k);                        
                    end
                end
            end
            % �����������
            chains{x} = chain;
        end
    end
end

