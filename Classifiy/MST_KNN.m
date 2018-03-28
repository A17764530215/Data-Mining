function [ IDX ] = MST_KNN( M, idx, L )
%MST_KNN �˴���ʾ�йش˺�����ժҪ
%
%   ����MST����ص��L�׽��ڣ�Ҳ��L�δ��ݱհ�
%   �˴���ʾ��ϸ˵��
%
%   M      -�ڽӾ���
%   idx    -MST�е���ص��±�
%   L      -����
%   IDX    -L�׽��ڵ��±�
    [m, ~] = size(idx);
    L1 = zeros(m, 1);
    T = M^(L+1);
    for i = 1 : m
        % T�е�i��ֵ����L���б��Ϊ1
        L1(T(idx(i, 1), :)>L, 1) = 1;
    end
    IDX = find(L1==1);
end

