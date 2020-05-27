function [ yTest, Time ] = LS_SVM( xTrain, yTrain, xTest, opts )
%LS_SVR 此处显示有关此函数的摘要
% Least Square Support Vector Machine
%   此处显示详细说明

X = xTrain;
Y = yTrain;
count = GetParamsCount(opts);
if count > 1
    % 网格搜索加速
    yTest = cell(count, 1);
    Time = zeros(count, 1);
    [ change, step ] = Change(opts);
    for i = 1 : count
        params = GetParams(opts, i);
        tic;
        if mod(i, step) ~= 1
            switch change 
                case 'C'
                    % 无需额外计算
                case 'p1'
                    % 重新带入参数p1
                    [ Q, I ] = Prepare(X, Y, params.kernel);
                otherwise
                    throw(MException('STL:LS_SVM', 'no parameter changed'));
            end
        else
            [ Q, I ] = Prepare(X, Y, params.kernel);
        end
        [ Alphab ] = Primal(Q, I, Y, params);
        [ Time(i,1) ] = toc;
        [ yTest{i} ] = Predict(xTest, X, Y, Alphab, params.kernel);
    end
else
    tic;
    [ Q, I ] = Prepare(X, Y, opts.kernel);
    [ Alphab ] = Primal(Q, I, Y, opts);
    Time = toc;
    [ yTest ] = Predict(xTest, X, Y, Alphab, opts.kernel);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('STL:LS_SVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('STL:LS_SVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ Q, I ] = Prepare(X, Y, kernel)
        Q = Y.*Kernel(X, X, kernel).*Y';
        I = speye(size(Q));
    end

    function [ Alphab ] = Primal(Q, I, Y, opts)
        H = Q + I/opts.C;
        E = ones(size(Y));
        Alphab = [H Y;Y' 0]\[E; 0];
    end

    function [ yTest ] = Predict(xTest, X, Y, Alphab, kernel)
        Alpha = Alphab(1:end-1);
        svi = Alpha~=0;
        b = Alphab(end);
        yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:)) + b);
    end

end