function [ Label ] = KNN( X, Y, x, k )
%KNN �˴���ʾ�йش˺�����ժҪ
%  K Nearest Neighbours
%
%    Usage: [ Label ] = KNN( X, Y, x, k )
%
%    Parameters: X     -Training inputs
%                Y     -Training targets
%                x     -Test input
%                k     -Neighbours count k
%
%   �˴���ʾ��ϸ˵��

    [m, ~] = size(X);
    xs = repmat(x, m, 1);
    % 1. ������֪������ݼ��ϻ��ܵĵ��뵱ǰ��ľ���
    dist = (sum((xs - X).^2, 2)).^0.5;
    % 2. ���վ����������
    [B, IX] = sort(dist, 'ascend');
    % 3. ѡȡ�뵱ǰ����������k����
    len = min(k, length(B));
    % 4. ѡȡ�������k�����г��ִ������������ΪԤ�����
    Label = mode(Y(IX(1:len)));
end
