function [ Xr, Yr, W ] = NDP( X, Y, k, th_p, th_n )
%NDP �˴���ʾ�йش˺�����ժҪ
% Neighbour Distribution Pattern
%   �˴���ʾ��ϸ˵��
% ������
%   X     -���ݼ�
%   Y     -��ǩ��
%   k     -������
%   th_p  -��������Һ���ֵ
%   th_n  -��������Һ���ֵ

    % Generating Dp'
    [Xp, Yp, Wp] = NDP_PART(X(Y==1,:), Y(Y==1,:), k, th_p);
    % Generating Dn'
    [Xn, Yn, Wn] = NDP_PART(X(Y==-1,:), Y(Y==-1,:), k, th_n);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    Xr = [Xp; Xn]; Yr = [Yp; Yn]; W = [Wp; Wn];
end