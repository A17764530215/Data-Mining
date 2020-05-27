function [ Count ] = GetPropertyCount(root)
%GETPROPERTYCOUNT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    % �õ�Ҷ�ڵ���Ŀ
    Count = 0;
    if isstruct(root)
        names = fieldnames(root);
        [m, ~] = size(names);
        for i = 1 : m
            SubParamTree = root.(names{i});
            Count = Count + GetPropertyCount(SubParamTree);
        end
    else
        Count = 1;
    end
end
