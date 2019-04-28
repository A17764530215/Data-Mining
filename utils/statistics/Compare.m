function [ Summary ] = Compare(Path, File, DataSets, INDICES, MethodA, MethodB) 
%COMPARE �˴���ʾ�йش˺�����ժҪ
% �Աȷ���A,B
%   �˴���ʾ��ϸ˵��

    n = length(DataSets);
    Result = cell(n, 1);
    ErrorParams = cell(n, 1);
    ErrorResult = cell(n, 1);
    State = zeros(n, 8);
    for i = INDICES
        D = DataSets(i);
        % Record
        try
            [ Result{i}, State(i,:) ] = CompareAB(Path, D, MethodA, MethodB);
            if State(i,1)~=1
                
                    % record errors
                    IParams = CreateParams(MethodB);
                    R = Result{i};
                    ERROR_ID = find(R(:,3)~=0);
                    ErrorParams{i} = IParams(ERROR_ID);
                    ErrorResult{i} = R(ERROR_ID,:);
                    fprintf('record error\n');
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
    Summary.Result = Result;
    Summary.State = State;
    Summary.ErrorParams = ErrorParams;
    Summary.ErrorResult = ErrorResult;
    save(File, 'Summary');
end