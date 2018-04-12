function [ S ] = TaskRalation( X )
%TASKRALATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    [m, ~] = size(X);
    S = zeros(m, m);
    for i = 1 : m
        for j = 1 : m
            Xi = X(i,:);
            Xj = X(j,:);
            S(i, j) = (Xi*Xj')/(norm(Xi)*norm(Xj));
        end
    end
    
end