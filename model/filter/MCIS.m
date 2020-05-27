function [ Xr, Yr ] = MCIS( X, Y, k, r )
%MCIS �˴���ʾ�йش˺�����ժҪ
% Multi-Class Instance Selection
%   �˴���ʾ��ϸ˵��
% ������
%    X   -���ݼ�
%    Y   -��ǩ��
%    k   -������
%    r   -��������
    
    [N, ~] = size(X);
    C = unique(Y);
    L = length(C);
    S = ones(N, 1);
    % 1. ��ÿһ������
    for i = 1 : L
        % 2. ��ÿһ��c���
        Sc = X(Y==C(i), :); Nc = length(Sc);         
        % 3. ��c����Ͻ���k��ֵ���࣬�õ�k����������
        [ ~, M ] = KMeans( Sc, k );
        [ Mx, ~ ] = SplitDataLabel(M); 
        % 4. ��ÿһ����������Mi
        for j = 1 : k
            % 5. ����x����������Mi�ľ���
            vx = X - Mx(j, :);
            D = sqrt(sum(vx.*vx, 2));
            [~, ix] = sort(D, 'ascend');
            % 6. ��� Nc >= r*N/3 + k
            if Nc >= (r*N/3 + k)
                ncb = (Nc - r*N/3)/k;                
                % 7. �Ƴ�c��㿿���������ĵ�ncb����
                for u = 1 : N
                    if Y(ix(u)) == C(i)
                        ncb = ncb - 1;
                        if ncb == 0
                            S(ix(u)) = 1;
                        end
                    end
                end
            end
            if Nc >= (r*N/3 + k)
                nc = r*N/3;
            else
                nc = Nc;
            end
            nl = (r*N - nc)/(k*(L-1));
            % 9. ѡ�������������ĵ�nl��������c��ĵ�
            for u = 1 : N
                if Y(ix(u)) ~= C(i)
                    nl = nl - 1;
                    S(ix(u)) = 1;
                    if nl == 0
                        break;
                    end
                end
            end
        end
    end
    Xr = X(S==1, :); Yr = Y(S==1, :);
end