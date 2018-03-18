classdef Classifier
    %CLASSIFIER �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        
    end
    
    methods (Static)
        function [ clf ] = CreateClf(params)
            switch(params.Name)
                case {'CSVM'}
                    clf = CSVM(params);
                case {'TWSVM'}
                    clf = TWSVM(params);
                case {'KTWSVM'}
                    clf = KTWSVM(params);
                case {'LSTWSVM'}
                    clf = LSTWSVM(params);
                case {'KNNSTWSVM'}
                    clf = KNNSTWSVM(params);
                otherwise                    
                    throw(MException('Classifier', 'δ֪��������'));
            end                    
        end
        function [ Count ] = GetPropertyCount(root)
            % �õ�Ҷ�ڵ���Ŀ
            Count = 0;
            if isstruct(root)
                names = fieldnames(root);
                [m, ~] = size(names);
                for i = 1 : m
                    SubParamTree = root.(names{i});
                    Count = Count + Classifier.GetPropertyCount(SubParamTree);
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
                    x = Classifier.GetParamsCount(child);
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
                wi = Classifier.GetParamsCount(child);
                % ȡ�õ�ǰλ��idx���õ���λnum
                idx = mod(index-1, wi)+1;
                index = ceil(index / wi);
                % �����ӽڵ�
                if isstruct(child)
                    Params.(name) = Classifier.GetParams(child, idx);
                else
                    Params.(name) = child(idx, :);
                end
            end
        end
        function [ Params ] = CreateParams(root)
            nParams = Classifier.GetParamsCount(root);
            for index = 1 : nParams
                Params(index) = Classifier.GetParams(root, index);
            end
        end        
    end
    
end