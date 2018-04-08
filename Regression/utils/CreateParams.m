function [ Params ] = CreateParams(root)
%CREATEPARAMS �˴���ʾ�йش����ժҪ
% �������������
%   �˴���ʾ��ϸ˵��
    
    nParams = GetParamsCount(root);
    Params = repmat(GetParams(root, 1), nParams, 1);
    for index = 2 : nParams
        Params(index) = GetParams(root, index);
    end
    
    function [ Count ] = GetPropertyCount(root)
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
    function [ Count ] = GetParamsCount(root)
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
    function [ Params ] = GetParams(root, index)
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
    
end