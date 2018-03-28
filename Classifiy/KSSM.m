function [ Xd, Yd ] = KSSM( X, Y, k )
%KSSM �˴���ʾ�йش˺�����ժҪ
% Knn-based Sample Selection Method
%   �˴���ʾ��ϸ˵��
% ������
%   X    -���ݼ�
%   Y    -��ǩ��
%   k    -������

    Xp = X(Y==1,:); Xn = X(Y==-1,:);
    Yp = Y(Y==1,:); Yn = Y(Y==-1,:);
    [p, ~] = size(Xp); [q, ~] = size(Xn);
    % 1: calculate the distance between samples from different classes
    D = zeros(q, p);
    for i = 1 : q
        for j = 1 : p
            D(i, j) = norm(Xn(i,:)-Xp(j,:));
        end
    end
    % Np, NnΪ���������֮������������
    fP = zeros(p, 1); fN = zeros(q, 1);    
    for i = 1 : p
        % for positive points, exists dij <= dc
        [~, idx] = sort(D(:,i), 'ascend');
        idx = idx(2:1+k);
        fN(idx) = 1;
    end
    for i = 1 : q
        % for negative points, exists dij <= dc
        [~, idx] = sort(D(i,:), 'ascend');
        idx = idx(2:1+k);
        fP(idx) = 1;
    end
    Xd = [Xp(fP==1,:); Xn(fN==1,:)];
    Yd = [Yp(fP==1,:); Yn(fN==1,:)];
end