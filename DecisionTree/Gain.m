function [ GDA ] = Gain( D )
%GAIN �˴���ʾ�йش˺�����ժҪ
%    Parameters: D      -���ݼ�D
%                A     -����A
%
%
%   �˴���ʾ��ϸ˵��
    % �õ����ݼ���С
    [~, n] = size(D);
    % ���㼯����ÿһ����������H(D)
    HD = Entropy(D);
    % ���㼯����ÿһ��������������H(D|A)
    HDA = zeros(1, n);
    for i = 1 : n
        % �ҳ�����������ȡֵ
        PropertySet = unique(D(:, i));
        [u, ~] = size(PropertySet);
        % ����ÿһ��������������
        for j = 1 : u
            % �õ���ȡֵ�ϵ������Ӽ�
            Dj = D(D(:, i)==PropertySet(j,:),:);
            [x, ~] = size(Dj);
            % ����������Ӽ�����
            Ent = Entropy(Dj);
            % �ۼ�������
            HDA = HDA + (x/u)*Ent;
        end
    end
    GDA = HD - HDA;    % Gain(D, A)
end

