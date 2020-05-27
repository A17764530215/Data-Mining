function [ Alpha, output ] = DCDM(H, f, lb, ub, opts)
%DCDM �˴���ʾ�йش˺�����ժҪ
% ��ż�����½���
%   �˴���ʾ��ϸ˵��

isTolCon = isfield(opts, 'TolCon');

L = size(H, 1);
Alpha = zeros(L, 1);
times = 0;
while true
    Alphak = Alpha;
    for k = 1 : L
        Gk = H(k,:)*Alpha+f(k);
        % ʹ��Alphaһֱ�ڿ�����
        Alpha(k) = max([min([Alpha(k) - Gk/H(k,k), ub]), lb]);
    end
    times = times + 1;
    Diff = Alpha-Alphak;
    if isTolCon && norm(Diff) < opts.TolCon
        output.message = sprintf('DCDM: stop at TolCon==%.8f > %.8f.', norm(Diff), opts.TolCon);
        break;
    end
end
end