function [ D ] = NDP( X, Y, k, th_p, th_n )
%CSSUM �˴���ʾ�йش˺�����ժҪ
% Cosine Sum Sample Selection
%
% ������
%   X     -���ݼ�
%   Y     -��ǩ��
%   k     -������
%   th_p  -��������Һ���ֵ
%   th_n  -��������Һ���ֵ
%
%   �˴���ʾ��ϸ˵��
    % Generating Dp'
    Dp = X(Y==1,:);
    idp = NDP_PART(Dp, k, th_p);
    Dp1 = Dp(idp,:);
    % Generating Dn'
    Dn = X(Y==-1,:);
    idn = NDP_PART(Dn, k, th_n);
    Dn1 = Dn(idn,:);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    D = [Dp1; Dn1];
end

