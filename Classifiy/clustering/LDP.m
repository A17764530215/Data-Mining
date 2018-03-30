function [ Xr, Yr, W ] = LDP( X, Y, k, rate )
%LDP �˴���ʾ�йش˺�����ժҪ
% Local Density Peaks Sample Selection
%   �˴���ʾ��ϸ˵��
% ������
%      X    -���ݼ�
%      Y    -��ǩ
%      n    -������
%      k    -����
%    Rho    -ɸѡ����

    % �����������ܶȷ�ֵ����
    [ C, ~, Rho, ~, ~, ~, ~, ~, ~, ~ ] = DP( X, k );
    [m, ~] = size(X);
    W = zeros(m, 1);
    for c = 1 : k
        % �ҳ�ͬ���
        ids = find(C==c);
        % ѡȡ�ֲ��ܶȷ�Χrate���µĵ�
        rho = Rho(ids);
        rho_cut = min(rho) + range(rho)*rate;
        retain = ids(rho < rho_cut);
        W(retain) = Rho(retain);
    end
    % �õ���ѡ����������±�
    WP = W > 0;
    Xr = X(WP, :); Yr = Y(WP, :);
end