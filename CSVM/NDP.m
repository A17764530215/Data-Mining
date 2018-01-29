function [ dX, dY ] = NDP( X, Y, k, th_p, th_n )
%CSSUM �˴���ʾ�йش˺�����ժҪ
% Cosine Sum Sample Selection
%   �˴���ʾ��ϸ˵��
% ������
%   X     -���ݼ�
%   Y     -��ǩ��
%   k     -������
%   th_p  -��������Һ���ֵ
%   th_n  -��������Һ���ֵ

    % Generating Dp'
    [Xp1, Yp1] = NDP_PART(X(Y==1,:), Y(Y==1,:), k, th_p);
    % Generating Dn'
    [Xn1, Yn1] = NDP_PART(X(Y==-1,:), Y(Y==-1,:), k, th_n);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    dX = [Xp1; Xn1]; dY = [Yp1; Yn1];
end
