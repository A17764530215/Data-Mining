function [ H ] = Entropy( D )
%ENTROPY �˴���ʾ�йش˺�����ժҪ
%    Properties: D        -�����б�
%                H        -���ݼ���ÿһ�����ϵ���
%   �˴���ʾ��ϸ˵��
    [m, n] = size(D);
    fprintf('size of D = [%d, %d]\n', m, n);
    % ��ʼ��
    H = zeros(1, n);    
    % ��ÿһ������
    for i = 1 : n
        % �ҳ�����������ȡֵ
        PropertySet = unique(D(:, i));
        [u, ~] = size(PropertySet);
        % ��ʼ������
        P = zeros(1, u);
        % �������е�ÿһ��ȡֵ
        for j = 1 : u
            % ��������ÿһ��ȡֵ���ֵĸ���
            if class(PropertySet(j,:)) == 'cell'
                P(:, j) = length(find(strcmp(D(:, i), PropertySet(j, :)))) / m;
            else
                P(:, j) = length(find(D(:, i)==PropertySet(j, :))) / m;
            end
        end
        fprintf('sum of Pj: %d\n', sum(P));
        H(:, i) = -sum(P.*log2(P));        
    end
end

