function [ Dr, T ] = Filter( D, ssm )
%FILTER 
% Sample Selection Method Wrapper
%   �˴���ʾ��ϸ˵��
% ������
%     ssm    -����ѡ���㷨
%       D    -���ݼ�
% ���أ�
%      Dr    -Լ�����ݼ�
%       T    -ʱ��

    % �ָ������ͱ�ǩ
    [X, Y] = SplitDataLabel(D);
    % ��ʼ��ʱ
    tic;
    % ѡ���㷨
    switch(ssm)
        case {'NPPS'}
            % 1. Neighbors Property Pattern Selection
            % Spiral distributed dataset
            [Xr, Yr] = NPPS(X, Y, 12);
        case {'NDP'}
            % 2. Neighbour Distribution Pattern
            % However, some reserved samples far away from decision plane have
            % no contribution to the performance of SVM and should be disposed
            [Xr, Yr] = NDP(X, Y, 24, 12, 12);
        case {'FNSSS'}
            % 3. Fixed Neighborhood Sphere Sample Selection (FNSSS)
            [Xr, Yr] = FNSSS(X, Y, 1, 200);
        case {'DSSM'}
            % 4. Distance-based Sample Selection Method
            [Xr, Yr] = DSSM(X, Y, 200);
        case {'KSSM'}
            % 5. Knn-based Sample Selection Method
            [Xr, Yr] = KSSM(X, Y, 12);
        case {'CBD'}
            % 6. Concept Boundary Detection
            % Spiral distributed dataset
            [Xr, Yr] = CBD(X, Y, 12, 2, 0.95);
        case {'MCIS'}
            % 7. Multi-Class Instance Selection
            % ref: Fast instance selection for speeding up support vector machines
            [Xr, Yr] = MCIS(X, Y, 2, 0.5);
        case {'BEPS'}
            % 8. Border-Edge Pattern Selection
            % ref: Selecting critical patterns based on local geometrical and statistical information
        case {'NSCP'}
            % 9. Non-Stable Cut Point Sample Selection
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