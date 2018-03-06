function [ D ] = Preprocess( DataSet )
%PREPROCESS �˴���ʾ�йش˺�����ժҪ
% Ԥ�������ݼ�
%   �˴���ʾ��ϸ˵��

    Data = DataSet.Data;
    [m, n] = size(Data);
    D = zeros(m, n);
    if istable(Data)
        VariableNames = Data.Properties.VariableNames;
        for i = 1 : n
            % ȡ������Col��cell����
            Col = Data{:, VariableNames{i}};                
            if iscell(Col)
                % ��ɢ����
                Classes = unique(Col);
                for j = 1 : length(Classes)                   
                    D(strcmp(Col, Classes{j}), i) = j;
                end
            elseif ismatrix(Col)
                % ��������
                D(:, i) = Col;
            else
                throw(MException('Preprocess:Table', 'Unrecognized column type'));
            end
        end
    elseif iscell(Data)
        throw(MException('Preprocess:Cell', 'Unsupported type'));
    elseif ismatrix(Data)
        D = Data;
    end
end