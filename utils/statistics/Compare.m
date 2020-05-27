function [ Summary ] = Compare(Path, File, DataSets, INDICES, MethodA, MethodB) 
%COMPARE 此处显示有关此函数的摘要
% 对比方法A,B
%   此处显示详细说明

    n = length(DataSets);
    Result = cell(n, 1);
    ErrorParams = cell(n, 1);
    ErrorResult = cell(n, 1);
    Rows = [];
    Stats = zeros(n, 12);
    for i = INDICES
        D = DataSets(i);
        % Record
        try
            [ Result{i}, Stats(i,:) ] = CompareAB(Path, D, MethodA, MethodB);
            Rows = cat(1, Rows, i);
            if Stats(i, 1) ~=1
                % record errors
                IParams = CreateParams(MethodB);
                R = Result{i};
                ERROR_ID = find(R(:,3)~=0);
                ErrorParams{i} = IParams(ERROR_ID);
                ErrorResult{i} = R(ERROR_ID,:);
                fprintf('record error in %d.\n', i);
            end
        catch ME
            if strcmp(ME.identifier, 'Stat:CompareAB')
                if strcmp(ME.message, 'No record file')
                    continue;
                end
            end
        end
    end
    fprintf('Compare finished\n');
    % convert to table
    VariableNames = {'Flag', 'S_0', 'S_c', 'T_0', 'T_c','K_0','K_1',...
        'Inactive', 'Screening', 'Speedup_1', 'Speedup_2', 'Speedup_3'};
    RowNames = {DataSets.Name};
    Stats = cell2table(num2cell(Stats), 'VariableNames', VariableNames, 'RowNames', RowNames);
    % save to file
    Summary.Result = Result;
    Summary.State = Stats;
    Summary.Screening = Stats(Rows,[2:5, 12, 11]);
    Summary.ErrorParams = ErrorParams;
    Summary.ErrorResult = ErrorResult;
    save(File, 'Summary');
end