function [ Data ] = Preprocess( Table )
%PREPROCESS �˴���ʾ�йش˺�����ժҪ
% Ԥ�������ݼ�
%   �˴���ʾ��ϸ˵��
% ���أ�
%    Data   ����
%    Map    ӳ���

    [m, n] = size(Table);
    Data = zeros(m, n);
    VariableNames = Table.Properties.VariableNames;
    for i = 1 : n
        % ȡ������Col��cell����
        Col = Table{:, VariableNames{i}};
        if isnumeric(Col)
            % Numerical
            Data(:, i) = Col;
        else
            if iscell(Col)
                Col = categorical(Col);
            end
            if iscategorical(Col)
                % Categorical
                Col = categorical(Col);
                Classes = categories(Col);
                for j = 1 : length(Classes)
                    Data(Col==Classes(j), i) = j;
                end
            else
                % ��������
                throw(MException('Preprocess/Table2Mat', 'Unrecognized column type'));
            end
        end
    end
end