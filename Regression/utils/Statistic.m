function [ OStat ] = Statistic( IStat )
%STATISTIC �˴���ʾ�йش˺�����ժҪ
% ͳ��ʵ������
%   �˴���ʾ��ϸ˵��

    [m, n] = size(IStat);
    OStat;
    % ��ÿһ�����ݼ�
    for i = 1 : m
        % ��ÿһ���㷨
        for j = 1 : n
            AStat = IStat{i, j};
            Stat = AStat{1, 4};
            % ��ÿһ������
            for t = 1 : TaskNum
                OStat(:,j,i) = Stat(:,:,t);
            end
        end        
    end
    
end

