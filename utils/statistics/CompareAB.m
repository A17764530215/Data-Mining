function [ Result, State ] = CompareAB(Path, D, MethodA, MethodB)
%COMPAREAB 此处显示有关此函数的摘要
% 比较筛选前后的准确率
%   此处显示详细说明

    try
        A = load([Path, MethodA.ID, '-', D.Name,'.mat']);
        B = load([Path, MethodB.ID, '-', D.Name,'.mat']);
    catch
        throw(MException('Stat:CompareAB','No record file'));
    end
    T = mean((A.CVTime-B.CVTime)./A.CVTime);
    C = permute(A.CVStat(:,1,:)==B.CVStat(:,1,:), [1 3 2]);
    % Result
    a = mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3);
    b = mean(A.CVStat(:,1,:) - B.CVStat(:,1,:), 3);
    % rate
    c = mean(C(:));
    avg = mean(B.CVRate, 1);
    Inactive = mean(avg(3)+avg(4), 1);
    Screening = mean(avg(1)+avg(2), 1);
    if size(B.CVRate, 2) > 4
        Error = max(B.CVRate(:,[5 6]));
    else
        Error = [-1 -1];
    end
    Result = [a, b, B.CVRate, A.CVTime, B.CVTime];
    State = [c, avg, Error, Inactive, Screening, T(1)];
    if c ~= 1
        fprintf('Error: %s %.9f\n', [Path, MethodB.ID, '-', D.Name,'.mat'], c);
    end
end