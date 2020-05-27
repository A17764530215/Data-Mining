function [ yTest, Time ] = vTWSVM(xTrain, yTrain, xTest, opts)
%VTWSVM 此处显示有关此函数的摘要
% $\nu$-Twin Support Vector Machine
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
                case 'v'
                    % 无需额外计算
                case 'p1'
                    % 重新带入参数p1
                    [ H, G, S2R, R2S, X, e1, e2, m1, m2 ] = Preppare(xTrain, yTrain, params.kernel);
                otherwise
                    throw(MException('STL:vTWSVM', 'no parameter changed'));
            end
        else
            [ H, G, S2R, R2S, X, e1, e2, m1, m2 ] = Preppare(xTrain, yTrain, params.kernel);
        end
        [ Alpha, Mu ] = Primal(H, G, e1, e2, m1, m2, params);
        [ Time(i,1) ] = toc;
        [ u1, b1, u2, b2 ] = GetWeight(S2R, R2S, Alpha, Mu);
        [ yTest{i} ] = Predict(xTest, X, u1, b1, u2, b2, params.kernel);
    end
else
    tic
    [ H, G, S2R, R2S, X, e1, e2, m1, m2 ] = Preppare(xTrain, yTrain, opts.kernel);
    [ Alpha, Mu ] = Primal(H, G, e1, e2, m1, m2, opts);
    Time = toc;
    [ u1, b1, u2, b2 ] = GetWeight(S2R, R2S, Alpha, Mu);
    [ yTest ] = Predict(xTest, X, u1, b1, u2, b2, opts.kernel);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.v ~= p2.v
            change = 'v';
            step = length(opts.v);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('STL:vTWSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('STL:vTWSVM', 'Change: no parameter changed'));
            end
        end
    end

    function [ H, G, S2R, R2S, X, e1, e2, m1, m2 ] = Preppare(xTrain, yTrain, kernel)
        symmetric = @(H) (H+H')/2;
        A = xTrain(yTrain==1, :);
        B = xTrain(yTrain==-1, :);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        % 构造核矩阵
        X = [A; B];
        S = [Kernel(A, X, kernel) e1];
        R = [Kernel(B, X, kernel) e2];
        S2R = Cond(S'*S)\R';
        R2S = Cond(R'*R)\S';
        H = symmetric(R*S2R);
        G = symmetric(S*R2S);
    end

    function [ Alpha, Beta ] = Primal(H, G, e1, e2, m1, m2, params)
        Alpha = quadprog(H,[],-e2',-params.v,[],[],zeros(m2, 1),e2/m2,[],params.solver);
        Beta = quadprog(G,[],-e1',-params.v,[],[],zeros(m1, 1),e1/m1,[],params.solver);
    end

    function [ u1, b1, u2, b2 ] = GetWeight(S2R, R2S, Alpha, Beta)
        % v-DTWSVM1
        z1 = -S2R*Alpha;
        u1 = z1(1:end-1);
        b1 = z1(end);
        % v-DTWSVM2
        z2 = R2S*Beta;
        u2 = z2(1:end-1);
        b2 = z2(end);
    end

    function [ yTest ] = Predict(xTest, X, u1, b1, u2, b2, kernel)
        K = Kernel(xTest, X, kernel);
        D1 = abs(K*u1+b1)/norm(u1);
        D2 = abs(K*u2+b2)/norm(u2);
        yTest = sign(D2-D1);
        yTest(yTest==0) = 1;
    end
end

