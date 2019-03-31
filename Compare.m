function [ d ] = Compare(Path, DataSets, INDICES, MethodA, MethodB) 
%COMPARE 此处显示有关此函数的摘要
% 对比方法A,B
%   此处显示详细说明

    n = length(DataSets);
    Result = cell(n, 1);
    ErrorParams = cell(n, 1);
    ErrorResult = cell(n, 1);
    State = zeros(n, 7);
    Error = zeros(n, 6);
    for i = INDICES
        D = DataSets(i);
        try
            A = load([Path, MethodA.ID, '-', D.Name,'.mat']);
            B = load([Path, MethodB.ID, '-', D.Name,'.mat']);
        catch
            fprintf('no record:%s\n', D.Name);
            continue;
        end
        T = mean((A.CVTime-B.CVTime)./A.CVTime);
        C = permute(A.CVStat(:,1,:)==B.CVStat(:,1,:), [1 3 2]);
        % Result
        IDX = B.CVRate>0;
        cnt = sum(IDX, 1);
        avg0 = mean(B.CVRate, 1);
        avg2 = mean(B.CVRate(IDX(:,2),1)./B.CVRate(IDX(:,2),2));
        a = mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3);
        b = mean(A.CVStat(:,1,:) - B.CVStat(:,1,:), 3);
        Result{i} = [a, b, a-b, B.CVRate, A.CVTime(:,1), B.CVTime(:,1)];
        if mean(C(:)) == 1
            fprintf('Success: %d\n', i);
            State(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, avg2, T(1)];
        else
            fprintf('Error: %d\n', i);
            Error(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, T(1)];
        end
        
        % record errors
        IParams = CreateParams(MethodB);
        R = Result{i};
        ERROR_ID = find(R(:,2)~=R(:,1));
        ErrorParams{i} = IParams(ERROR_ID);
        ErrorResult{i} = R(ERROR_ID,:);
    end
    
    d.Result = Result;
    d.State = State;
    d.Error = Error;
    d.ErrorParams = ErrorParams;
    d.ErrorResult = ErrorResult;
end