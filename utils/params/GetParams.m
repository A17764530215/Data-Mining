function [ Params ] = GetParams(root, index)
%GETPARAMS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    names = fieldnames(root);
    [m, ~] = size(names);
    % �ֽ��±�
    for i = 1 : m
        name = names{i};
        child = root.(name);
        wi = GetParamsCount(child);
        % ȡ�õ�ǰλ��idx���õ���λnum
        idx = mod(index-1, wi)+1;
        index = ceil(index / wi);
        % �����ӽڵ�
        if isstruct(child)
            Params.(name) = GetParams(child, idx);
        else
            Params.(name) = child(idx, :);
        end
    end
end