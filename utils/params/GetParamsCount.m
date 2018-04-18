function [ Count ] = GetParamsCount(root)
%GETPARAMSCOUNT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    % ��ȡ���в����������
    Count = 1;
    if isstruct(root)
        names = fieldnames(root);
        [m, ~] = size(names);
        for i = 1 : m
            child = root.(names{i});
            x = GetParamsCount(child);
            Count = Count * x;
        end
    else
        [m, ~] = size(root);
        Count = Count * m;
    end
end
