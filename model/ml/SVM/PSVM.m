function  [ yTest, Time ] = PSVM( xTrain, yTrain, xTest, opts )
%PSVM 此处显示有关此函数的摘要
% Proximal Support Vector Machine
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
                    [ Q, I, e ] = Prepare(X, Y, params.kernel);
                otherwise
                    throw(MException('STL:PSVM', 'no parameter changed'));
            end
        else
            [ Q, I, e ] = Prepare(X, Y, params.kernel);
        end
        [ Alpha ] =  Primal(Q, I, e, params);
        [ Time(i,1) ] = toc;
        [ yTest{i} ] = Predict(xTest, X, Y, Alpha, params.kernel);
    end
else
    tic;
    [ Q, I, e ] = Prepare(X, Y, opts.kernel);
    [ Alpha ] =  Primal(Q, I, e, opts);
    Time = toc;
    [ yTest ] = Predict(xTest, X, Y, Alpha, opts.kernel);
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
                    throw(MException('STL:PSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('STL:PSVM', 'Change: no parameter changed'));
            end
        end
    end

    function  [ Q, I, e ] = Prepare(X, Y, kernel)
        H = Kernel(X, X, kernel);
        Q = Y.*(H + 1).*Y';
        I = speye(size(H));
        e = ones(size(Y));
    end

    function [ Alpha ] =  Primal(Q, I, e, opts)
        Alpha = Cond(Q + I/opts.C)\e;
    end

    function [ yTest ] = Predict(xTest, X, Y, Alpha, kernel)
        svi = Alpha~=0;
        b = Y(svi,:)'*Alpha(svi,:);
        yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:)) + b);
        yTest(yTest==0) = 1;
    end

end