function [ idx ] = KNN( M, x, k )
%KNN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [~, idx] = sort(M(x,:), 'ascend');
    idx = idx(:,2:1+k);
end

