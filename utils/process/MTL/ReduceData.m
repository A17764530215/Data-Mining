function [ Xr, Yr ] = ReduceData( X, Y, count, biased )
%REDUCEDATA 此处显示有关此函数的摘要
% 约减数据集
%   此处显示详细说明

    T = length(X);
    Xr = cell(T, 1);
    Yr = cell(T, 1);
    if biased == false
        for t = 1 : T
            N = size(Y{t}, 1);
            idx = randperm(N, count);
            Xr{t, 1} = X{t, 1}(idx,:);
            Yr{t, 1} = Y{t, 1}(idx,:);
        end
    else
        for t = 1 : T
            Yt = Y{t};
            Ip = find(Yt==1);
            In = find(Yt==-1);
            [ Ip, In ] = Reduce(Ip, In, count);
            [ Xr{t, 1}, Yr{t, 1} ] = Select(X{t, 1}, Ip, In);
        end
    end

    %% Subsampling
    function [ Ip, In ] = Reduce(Ip, In, count)
    % 欠采样、保留count个样本
        Np = size(Ip, 1);
        Nn = size(In, 1);
        if count > 0
            Cn = Np + Nn - count;
            if Np > Nn
                Ip(randperm(Np, Cn),:) = [];
            else
                In(randperm(Nn, Cn),:) = [];
            end
        else
            fprintf('No reduce of data.\n');
        end
    end

%% Select data
    function [ Xr, Yr ] = Select(X, Ip, In)
    % 调整标签
        
        Xp = X(Ip, :);
        Yp = ones(size(Xp, 1), 1);
        Xn = X(In, :);
        Yn = -ones(size(Xn, 1), 1);
        Xr = [Xp; Xn];
        Yr = [Yp; Yn];
    end
end

