function [ Y ] = PCA(X, n)
%PCA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [coeff, score, latent] = pca(X);
    Y = X*coeff;
end