function [ Alpha1 ] = DVI_H(H0, H1, Alpha0, C1)
%DVI_H �˴���ʾ�йش˺�����ժҪ
% safe screening rules for $\mu$, $p$
%   �˴���ʾ��ϸ˵��

P = chol(H1, 'upper');
L0 = H0*Alpha0;
L1 = H1*Alpha0;
LL = (L0+L1);
% �;���
% A = P'\(L0)+P*Alpha0;
% RR = sqrt(sum(P.*P, 1)'*((A'*A)/4-Alpha0'*L0));
% �߾���
RR = sqrt(sum(P.*P, 1)'*(L0'*(H1\L0)+Alpha0'*(L1-2*L0)));
Alpha1 = Inf(size(Alpha0));
Alpha1(LL - RR > 2) = 0;
Alpha1(LL + RR < 2) = C1;
end