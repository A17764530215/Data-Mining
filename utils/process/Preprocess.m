function [ Data ] = Preprocess( Table )
%PREPROCESS 此处显示有关此函数的摘要
% 预处理数据集
%   此处显示详细说明
% 返回：
%    Data   数据
%    Map    映射表

    [m, n] = size(Table);
    Data = zeros(m, n);
    VariableNames = Table.Properties.VariableNames;
    for i = 1 : n
        % 取出来的Col是cell类型
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
                % 其他类型
                throw(MException('Preprocess/Table2Mat', 'Unrecognized column type'));
            end
        end
    end
end