function [ yTest, Time ] = LSTWSVM(xTrain, yTrain, xTest, opts)
%LSTWSVM 此处显示有关此类的摘要
% Least Square Twin Support Vector Machine

%   此处显示详细说明
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
                    [ X, E, F, E2, F2, e1, e2, n] = Prepare(xTrain, yTrain, params.kernel);
                otherwise
                    throw(MException('STL:LSTWSVM', 'no parameter changed'));
            end
        else
            [ X, E, F, E2, F2, e1, e2, n] = Prepare(xTrain, yTrain, params.kernel);
        end
        [ w1, b1, w2, b2 ] = Primal(E, F, E2, F2, e1, e2, n, params);
        [ Time(i,1) ] = toc;
        [ yTest{i} ] = Predict(xTest, X, w1, b1, w2, b2, params.kernel);
    end
else
    tic
    [ X, E, F, E2, F2, e1, e2, n] = Prepare(xTrain, yTrain, opts.kernel);
    [ w1, b1, w2, b2 ] = Primal(E, F, E2, F2, e1, e2, n, opts);
    Time = toc;
    [ yTest ] = Predict(xTest, X, w1, b1, w2, b2, kernel);
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
                    throw(MException('STL:LSTWSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('STL:LSTWSVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ X, E, F, E2, F2, e1, e2, n] = Prepare(xTrain, yTrain, kernel)
        A = xTrain(yTrain==1, :);
        B = xTrain(yTrain==-1, :);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        n = m1 + m2;
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        % 构造核矩阵
        X = [A; B];
        E = [Kernel(A, X, kernel) e1];
        F = [Kernel(B, X, kernel) e2];
        E2 = E'*E;
        F2 = F'*F;
    end

    function [ w1, b1, w2, b2 ] = Primal(E, F, E2, F2, e1, e2, n, params)
        % LS-TWSVM1
        u1 = -Cond(F2+1/params.C*E2)\F'*e2;
        w1 = u1(1:n);
        b1 = u1(end);
        % LS-TWSVM2
        u2 = Cond(E2+1/params.C*F2)\E'*e1;
        w2 = u2(1:n);
        b2 = u2(end);
    end

    function [ yTest ] = Predict(xTest, X, w1, b1, w2, b2, kernel)
        K = Kernel(xTest, X, kernel);
        D1 = abs(K*w1+b1)/norm(w1);
        D2 = abs(K*w2+b2)/norm(w2);
        yTest = sign(D2-D1);
        yTest(yTest==0) = 1;
    end
end