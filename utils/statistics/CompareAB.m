function [ Result, State ] = CompareAB(Path, D, MethodA, MethodB)
%COMPAREAB �˴���ʾ�йش˺�����ժҪ
% �Ƚ�ɸѡǰ���׼ȷ��
%   �˴���ʾ��ϸ˵��

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
    Result = [a, b, B.CVRate, A.CVTime, B.CVTime];
    if size(avg, 2) == 4
        State = [c, avg, 0, 0, Inactive, Screening, T(1)];
    else
        State = [c, avg, Inactive, Screening, T(1)];
    end
    if c ~= 1
        fprintf('Error: %s %.9f\n', [Path, MethodB.ID, '-', D.Name,'.mat'], c);
    end
end