function [ D ] = Curve( m, n, TaskNum )
%CURVE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    D = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Xt = rand(m, n);
        Wt = 20*t*rand(n, 1);
        Yt = Xt*Wt + (rand(m, 1)-0.5);
        D{t} = [Xt Yt];
    end
end