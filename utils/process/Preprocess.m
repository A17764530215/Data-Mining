function [ Data ] = Preprocess( Raw, AttributeTypes )
%PREPROCESS �˴���ʾ�йش˺�����ժҪ
% Ԥ�������ݼ�
%   �˴���ʾ��ϸ˵��

    if istable(Raw)
        Data = Table2Mat(Raw, AttributeTypes);
    elseif iscell(Raw)
        Data = Cell2Mat(Raw, AttributeTypes);
    elseif ismatrix(Raw)
        Data = Raw;
    end
    
    function [ D ] = Table2Mat(Table, AttributeTypes)
        [m, n] = size(Table);
        D = zeros(m, n);
        VariableNames = Table.Properties.VariableNames;
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Table{:, VariableNames{i}};
            if AttributeTypes(i) == 1
                % Real
                D(:, i) = Col;
            elseif AttributeTypes(i) == 2
                % Integer
                D(:, i) = Col;
            elseif AttributeTypes(i) == 3
                % Categorical
                Classes = unique(Col);
                for j = 1 : length(Classes)
                    D(strcmp(Col, Classes{j}), i) = j;
                end
            else
                % ��������
                throw(MException('Preprocess/Table2Mat', 'Unrecognized column type'));
            end
        end
    end

    function [ D ] = Cell2Mat(Cell, AttributeTypes)
        [m, n] = size(Cell);
        D = zeros(m, n);
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Cell(:, i);
            if AttributeTypes(i) == 1
                % Real
                D(:, i) = cell2mat(Col);
            elseif AttributeTypes(i) == 2
                % Integer
                D(:, i) = cell2mat(Col);
            elseif AttributeTypes(i) == 3
                % Categorical
                Classes = unique(Col);
                for j = 1 : length(Classes)
                    D(strcmp(Col, Classes{j}), i) = j;
                end
            else
                % ��������
                throw(MException('Preprocess/Cell2Mat', 'Unrecognized column type'));
            end
        end
    end
end