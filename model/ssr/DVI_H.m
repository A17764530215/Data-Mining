function [ Alpha1 ] = DVI_H(H0, H1, Alpha0, C1)
%DVI_H 此处显示有关此函数的摘要
% safe screening rules for $\mu$, $p$
%   此处显示详细说明

    P = chol(H1, 'upper');
    L0 = H0*Alpha0;
    L1 = H1*Alpha0;
    LL = (L0+L1)/2;
    RR = sqrt(sum(P.*P, 1))'*sqrt(L0'*(H1\L0)/4+Alpha0'*(L1/4-L0/2));
    Alpha1 = Inf(size(Alpha0));
    Alpha1(LL - RR > 1) = 0;
    Alpha1(LL + RR < 1) = C1;
end