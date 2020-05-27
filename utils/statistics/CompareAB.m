function [ Result, Stats ] = CompareAB(Path, D, MethodA, MethodB)
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
    S = mean(A.CVTime./B.CVTime);
    P = mean(A.CVTime)./mean(B.CVTime);
    C = permute(A.CVStat(:,1,:)==B.CVStat(:,1,:), [1 3 2]);
    % Result
    a = mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3);
    b = mean(A.CVStat(:,1,:) - B.CVStat(:,1,:), 3);
    % rate
    c = mean(C(:));
    avg = mean(B.CVRate, 1)*100;
    Inactive = mean(avg(3)+avg(4), 1);
    Screening = mean(avg(1)+avg(2), 1);
    Result = [a, b, B.CVRate, A.CVTime, B.CVTime];
    if size(avg, 2) == 4
        Stats = [c, avg, 0, 0, Inactive, Screening, T(1), S(1), P(1)];
    else
        Stats = [c, avg, Inactive, Screening, T(1), S(1), P(1)];
    end
    % safe test
    if c ~= 1
        fprintf('Error: %s %.9f\n', [Path, MethodB.ID, '-', D.Name,'.mat'], c);
    end
end