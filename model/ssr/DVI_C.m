function [ Alpha1 ] = DVI_C(H1, Alpha0, C1, C0)
%DVI_C �˴���ʾ�йش˺�����ժҪ
% safe screening rules for $C$
%   �˴���ʾ��ϸ˵��

c1 = (C1+C0)/C0;
c2 = (C1-C0)/C0;
P = chol(H1, 'upper');
L0 = H1*Alpha0;
LL = L0*c1;
RR = sqrt(sum(P.*P, 1)'*(Alpha0'*L0))*c2;
Alpha1 = Inf(size(Alpha0));
Alpha1(LL - RR > 2) = 0;
Alpha1(LL + RR < 2) = C1;
end