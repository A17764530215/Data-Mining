function [ Dr, T ] = SSMWrapper( D, ssm )
%SSMWraper �˴���ʾ�йش˺�����ժҪ
% Sample Selection Method Wrapper
%   �˴���ʾ��ϸ˵��
% ������
%     ssm    -����ѡ���㷨
%       D    -���ݼ�
%

    % �ָ������ͱ�ǩ
    [X, Y] = SplitDataLabel(D);
    % ��ʼ��ʱ
    tic;
    % ѡ���㷨
    switch(ssm)
        case {'NPPS'}
            % ���������ģʽѡ��
            [Xr, Yr] = NPPS(X, Y, 16);
        case {'NDP'}
            % ���Һ�ģʽѡ��
            [Xr, Yr] = NDP(X, Y, 24, 12, 12);
        case {'FNSSS'}
            % �̶�����������ѡ��
            [Xr, Yr] = FNSSS(X, Y, 1, 800);
        case {'DSSM'}
            % ���ھ��������ѡ�񷽷�
            [Xr, Yr] = DSSM(X, Y, 800);
        case {'KSSM'}
            % ����k���ڵ�����ѡ��
            [Xr, Yr] = KSSM(X, Y, 6);
        case {'NSCP'}
            % ���ȶ��ָ������ѡ��
            [Xr, Yr] = NSCP(X, Y, 1);
        case {'ALL'}
            % ȫ������
            Xr = X; Yr = Y;
        otherwise
            Xr = X; Yr = Y;
    end
    % ֹͣ��ʱ
    T = toc;
    % �ϲ������ͱ�ǩ
    Dr = [Xr, Yr];
end