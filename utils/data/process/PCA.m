function [ Y ] = PCA( X, percent )
%PCA 此处显示有关此函数的摘要
% 降维
%   此处显示详细说明
    [~,SCORE,LATENT] = pca(X);
    S = cumsum(LATENT)./sum(LATENT);
    index = find(S>percent);
    Y = SCORE(:,1:index(1));
end

