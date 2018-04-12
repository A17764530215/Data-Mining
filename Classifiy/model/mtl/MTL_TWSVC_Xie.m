function [ yTest, Time ] = MTL_TWSVC_Xie( xTrain, yTrain, xTest, opts )
%MTL_TWSVC_XIE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


%% Prepare
    tic;
    % �õ����е������ͱ�ǩ�Լ�������
    [ TaskNum, ~ ] = size(xTrain);  
    A = []; Y = []; T = [];
    for t = 1 : TaskNum
        % �õ�����i��H����
        Xt = xTrain{t};
        A = cat(1, A, Xt);
        % �õ�����i��Y����
        Yt = yTrain{t};
        Y = cat(1, Y, Yt);
        % ���������±�
        [m, ~] = size(Yt);
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A; % �����˱任����
    A = [Kernel(A, C, kernel) e]; % �����Ա任

end

