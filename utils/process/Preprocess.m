function [ Data, Map ] = Preprocess( Raw, AttributeTypes )
%PREPROCESS �˴���ʾ�йش˺�����ժҪ
% Ԥ�������ݼ�
%   �˴���ʾ��ϸ˵��
% AttributeTypes��
%   1: Real, 2: Integer, 3: Categorical

    if istable(Raw)
        [ Data, Map ] = Table2Mat(Raw, AttributeTypes);
    elseif iscell(Raw)
        [ Data, Map ] = Cell2Mat(Raw, AttributeTypes);
    elseif ismatrix(Raw)
        Data = Raw;
        Map = [];
    end
    
    function [ Data, Map ] = Table2Mat(Table, AttributeTypes)
        [m, n] = size(Table);
        Data = zeros(m, n);
        VariableNames = Table.Properties.VariableNames;
        Map = cell(1, n);
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Table{:, VariableNames{i}};
            if AttributeTypes(i) == 1
                % Real
                Data(:, i) = Col;
            elseif AttributeTypes(i) == 2
                % Integer
                Data(:, i) = Col;
            elseif AttributeTypes(i) == 3
                % Categorical
                Classes = unique(Col);
                for j = 1 : length(Classes)
                    Data(strcmp(Col, Classes{j}), i) = j;
                end
                Map{1, i} = Classes;
            else
                % ��������
                throw(MException('Preprocess/Table2Mat', 'Unrecognized column type'));
            end
        end
    end

    function [ Data, Map ] = Cell2Mat(Cell, AttributeTypes)
        [m, n] = size(Cell);
        Data = zeros(m, n);
        Map = cell(1, n);
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Cell(:, i);
            if AttributeTypes(i) == 1
                % Real
                Data(:, i) = cell2mat(Col);
            elseif AttributeTypes(i) == 2
                % Integer
                Data(:, i) = cell2mat(Col);
            elseif AttributeTypes(i) == 3
                % Categorical
                Classes = unique(Col);
                for j = 1 : length(Classes)
                    Data(strcmp(Col, Classes{j}), i) = j;
                end
                Map{1, i} = Classes;
            else
                % ��������
                throw(MException('Preprocess/Cell2Mat', 'Unrecognized column type'));
            end
        end
    end
end