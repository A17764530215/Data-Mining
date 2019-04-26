function [ Xr, Yr ] = ReduceMTL( X, Y, Task, Label )
%REDUCEMTL �˴���ʾ�йش˺�����ժҪ
% Լ�����������ݼ�
%   �˴���ʾ��ϸ˵��

    TaskNum = length(Task);
    % ѡȡ����
    TX = X(Task, 1);
    TY = Y(Task, 1);
    Xr = cell(TaskNum, 1);
    Yr = cell(TaskNum, 1);
    % ѡȡ����
    for t = 1 : TaskNum
        X = TX{t};
        Y = TY{t};
        % ѡȡ�������
        IDX = Y==Label(1)|Y==Label(2);
        Xr{t, 1} = X(IDX,:);
        % ������ǩ
        YR = Y(IDX,:);
        YR(YR==Label(1)) = -1;
        YR(YR==Label(2)) = 1;
        Yr{t, 1} = YR;
    end
end