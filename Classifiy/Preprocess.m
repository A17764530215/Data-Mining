function [ D ] = Preprocess( DataSet )
%PREPROCESS �˴���ʾ�йش˺�����ժҪ
% Ԥ�������ݼ�
%   �˴���ʾ��ϸ˵��

    Data = DataSet.Data;
    AttributeTypes = DataSet.AttributeTypes;
    [m, n] = size(Data);
    D = zeros(m, n);
    if istable(Data)
        VariableNames = Data.Properties.VariableNames;
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Data{:, VariableNames{i}};
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
                throw(MException('Preprocess:Table', 'Unrecognized column type'));
            end
        end
    elseif iscell(Data)
        throw(MException('Preprocess:Cell', 'Unsupported Data Type'));
    elseif ismatrix(Data)
        D = Data;
    end
end