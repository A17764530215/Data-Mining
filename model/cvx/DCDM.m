function [ Alpha, output ] = DCDM(H, f, lb, ub, opts)
%DCDM 此处显示有关此函数的摘要
% 对偶坐标下降法
%   此处显示详细说明

isTolCon = isfield(opts, 'TolCon');

L = size(H, 1);
Alpha = zeros(L, 1);
times = 0;
while true
    Alphak = Alpha;
    for k = 1 : L
        Gk = H(k,:)*Alpha+f(k);
        if Alpha(k) == lb
            PG = min([Gk, 0]); % 不能再降
        elseif Alpha(k) == ub
            PG = max([Gk, 0]); % 不能再升
        else
            PG = Gk; % 可行方向
        end
        if PG ~= 0
            % 使得Alpha一直在可行域
            Alpha(k) = min([max([Alpha(k) - Gk/H(k,k), lb]), ub]);
        end
    end
    times = times + 1;
    Diff = Alpha-Alphak;
    if isTolCon && norm(Diff) < opts.TolCon
        output.message = sprintf('DCDM: stop at TolCon==%.8f > %.8f.', norm(Diff), opts.TolCon);
        break;
    end
end
end