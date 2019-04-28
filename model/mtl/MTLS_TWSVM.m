function [ yTest, Time ] = MTLS_TWSVM(xTrain, yTrain, xTest, opts)
%MTLS_TWSVM 此处显示有关此函数的摘要
% Multi-Task Least Square Twin Support Vector Machine
%   此处显示详细说明

TaskNum = length(xTrain);
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
if isfield(opts, 'smw') && opts.smw
    tic;
    [ yTest, Time ] = GridSMWPrimal(X, Y, N, TaskNum, xTest, opts);
    toc;
else
    tic
    [ yTest, Time ] = GridPrimal(X, Y, N, TaskNum, xTest, opts);
    toc;
end

function [ yTest, Time ] = GridPrimal(X, Y, N, TaskNum, xTest, opts)
% 网格搜索加速
    count = GetParamsCount(opts);
    yTest = cell(count, 1);
    Time = zeros(count, 1);
    if count > 1
        [ change, step ] = Change(opts);
        for i = 1 : count
            params = GetParams(opts, i);
            tic;
            if mod(i, step) == 1 || strcmp(change, 'p1')
                [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2 ] = Prepare(X, Y, N, TaskNum, params.kernel);
            end
            [ Alpha, Gamma ] = Primal(Q, P, R, S, TaskNum, e1, e2, params);
            Time(i, 1) = toc;
            [ U, V ] = GetWeight(Alpha, Gamma, N, EEF, FFE, EEFc, FFEc, TaskNum, params);
            [ yTest{i} ] = Predict(xTest, X, U, V, TaskNum, params.kernel);
        end
    else
        tic;
        [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2 ] = Prepare(X, Y, N, TaskNum, opts.kernel);
        [ Alpha, Gamma ] = Primal(Q, P, R, S, TaskNum, e1, e2, opts);
        Time = toc;
        [ U, V ] = GetWeight(Alpha, Gamma, N, EEF, FFE, EEFc, FFEc, TaskNum, opts);
        [ yTest ] = Predict(xTest, X, U, V, TaskNum, opts.kernel);        
    end
    
    function [ Q, P, R, S, EEF, FFE, EEFc, FFEc, e1, e2 ] = Prepare(X, Y, N, TaskNum, kernel)
        % 分割正负类点
        A = X(Y==1,:);
        B = X(Y==-1,:);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        % 核函数
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);        
        if strcmp(kernel.type, 'linear')
            E = [Kernel(A, X, kernel) e1];
            F = [Kernel(B, X, kernel) e2];
        else
            E = [A e1];
            F = [B e2];
        end
        % 得到Q,R矩阵
        EEF = Cond(E'*E)\F';
        FFE = Cond(F'*F)\E';
        Q = F*EEF; R = E*FFE;
        % 得到P,S矩阵
        Ec = mat2cell(E, N(1,:));
        Fc = mat2cell(F, N(2,:));
        EEFc = cell(TaskNum, 1);
        FFEc = cell(TaskNum, 1);
        P = cell(TaskNum, 1);
        S = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = Ec{t}; Ft = Fc{t};
            EEFc{t} = Cond(Et'*Et)\(Ft');
            FFEc{t} = Cond(Ft'*Ft)\(Et');
            P{t} = Ft*EEFc{t};
            S{t} = Et*FFEc{t};
        end
        P = spblkdiag(P{:});
        S = spblkdiag(S{:});
    end
    
    function [ Alpha, Gamma ] = Primal(Q, P, R, S, TaskNum, e1, e2, opts)
        % MTL-LS-TWSVM1
        I = speye(size(Q));
        Alpha = Cond(Q + TaskNum/opts.rho*P + 1/opts.C*I)\e2;
        % MTL-LS-TWSVM2
        I = speye(size(R));
        Gamma = Cond(R + TaskNum/opts.rho*S + 1/opts.C*I)\e1;
    end

end

function [ yTest, Time ] = GridSMWPrimal(X, Y, N, TaskNum, xTest, opts)
% 网格搜索加速
    count = GetParamsCount(opts);
    yTest = cell(count, 1);
    Time = zeros(count, 1);
    if count > 1
        [ change, step ] = Change(opts);
        for i = 1 : count
            params = GetParams(opts, i);
            tic;
            if mod(i, step) == 1 || strcmp(change, 'p1')
                [ E, F, EE, FF, EEF, FFE, Ec, Fc, EEc, FFc, EEFc, FFEc, e1, e2 ] = SMWPrepare(X, Y, N, TaskNum, params.kernel);
            end
            [ Alpha, Gamma ] = SMW_Primal(E, F, EE, FF, Ec, Fc, EEc, FFc, TaskNum, e1, e2, params);
            Time(i, 1) = toc;
            [ U, V ] = GetWeight(Alpha, Gamma, N, EEF, FFE, EEFc, FFEc, TaskNum, params);
            [ yTest{i} ] = Predict(xTest, X, U, V, TaskNum, params.kernel);
        end
    else
        tic;
        [ E, F, EE, FF, EEF, Ec, Fc, FFE, EEc, FFc, EEFc, FFEc, e1, e2 ] = SMWPrepare(X, Y, N, TaskNum, opts.kernel);
        [ Alpha, Gamma ] = SMW_Primal(E, F, EE, FF, Ec, Fc, EEc, FFc, TaskNum, e1, e2, opts);
        Time = toc;
        [ U, V ] = GetWeight(Alpha, Gamma, N, EEF, FFE, EEFc, FFEc, TaskNum, opts);
        [ yTest ] = Predict(xTest, X, U, V, TaskNum, opts.kernel);
    end
    
    function [ E, F, EE, FF, EEF, FFE, Ec, Fc, EEc, FFc, EEFc, FFEc, e1, e2 ] = SMWPrepare(X, Y, N, TaskNum, kernel)
        % 分割正负类点
        A = X(Y==1,:);
        B = X(Y==-1,:);
        [m1, ~] = size(A);
        [m2, ~] = size(B);
        % 核函数
        e1 = ones(m1, 1);
        e2 = ones(m2, 1);
        if strcmp(kernel.type, 'linear')
            E = [Kernel(A, X, kernel) e1];
            F = [Kernel(B, X, kernel) e2];
        else
            E = [A e1];
            F = [B e2];
        end
        % 得到EE,FF矩阵
        EE = E'*E;
        FF = F'*F;
        EEF = Cond(E'*E)\F';
        FFE = Cond(F'*F)\E';
        % 得到EEc,FFc矩阵
        Ec = mat2cell(E, N(1,:));
        Fc = mat2cell(F, N(2,:));
        EEc = cell(TaskNum, 1);
        FFc = cell(TaskNum, 1);
        EEFc = cell(TaskNum, 1);
        FFEc = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = Ec{t}; Ft = Fc{t};
            EEc{t} = Et'*Et;
            FFc{t} = Ft'*Ft;
            EEFc{t} = Cond(Et'*Et)\(Ft');
            FFEc{t} = Cond(Ft'*Ft)\(Et');
        end
    end

    function [ Alpha, Gamma ] = SMW_Primal(A, B, AA, BB, Ac, Bc, AAc, BBc, TaskNum, e1, e2, opts)
        
        [ invD1 ] = BlockInverion(Bc, AAc, BBc, TaskNum, opts.rho, opts.C);
        [ invD2 ] = BlockInverion(Ac, BBc, AAc, TaskNum, opts.rho, opts.C);
        [ Alpha ] = SMW_Solve(invD1, B, AA, B', e2);
        [ Gamma ] = SMW_Solve(invD2, A, BB, A', e1);
    end
    
    function [ r ] = SMW_Solve(invD, U, invC, V, e)
        r = (invD*e-invD*U*(Cond(invC + V*invD*U)\(V*invD*e)));
    end
    
    function [ invD ] = BlockInverion(Bc, AAc, BBc, TaskNum, rho, c)
        invD = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Ct = Bc{t}/Cond(rho/TaskNum*AAc{t}+ c*BBc{t})*Bc{t}';
            It = speye(size(Ct));
            invD{t} = c*(It-c*Ct);
        end
        invD = spblkdiag(invD{:});
    end
    
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.rho1 ~= p2.rho1
            change = 'mu';
            step = length(opts.rho1);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(opts.kernel.p1);
                else
                    throw(MException('MTL:DMTSVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:DMTSVM', 'Change: no parameter changed'));
            end
        end
    end
 
    function [ U, V ] = GetWeight(Alpha, Gamma, N, EEF, FFE, EEFc, FFEc, TaskNum, opts)
        CAlpha = mat2cell(Alpha, N(2,:));
        CGamma = mat2cell(Gamma, N(1,:));
        u = -EEF*Alpha;
        v = FFE*Gamma;
        U = cell(TaskNum, 1);
        V = cell(TaskNum, 1);
        for t = 1 : TaskNum
            U{t} = u-EEFc{t}*(TaskNum/opts.rho*CAlpha{t});
            V{t} = v+FFEc{t}*(TaskNum/opts.rho*CGamma{t});
        end
    end

    function [ yTest ] = Predict(xTest, X, U, V, TaskNum, kernel)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Et = xTest{t};
            [m, ~] = size(Et);
            et = ones(m, 1);
            KAt = [Kernel(Et, X, kernel) et];
            D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
            D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
            yt = sign(D2-D1);
            yt(yt==0) = 1;
            yTest{t} = yt;
        end
    end

end