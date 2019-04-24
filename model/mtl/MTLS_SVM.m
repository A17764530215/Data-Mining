function [ yTest, Time ] = MTLS_SVM(xTrain, yTrain, xTest, opts)
%MTLS_SVM �˴���ʾ�йش˺�����ժҪ
% Multi-task least-squares support vector machines
%   �˴���ʾ��ϸ˵��

TaskNum = length(xTrain);
[ X, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
count = GetParamsCount(opts);
if count > 1
    % ������������
    yTest = cell(count, 1);
    Time = zeros(count, 1);
    [ change, step ] = Change(opts);
    for i = 1 : count
        params = GetParams(opts, i);
        tic;
        if mod(i, step) ~= 1
            switch change 
                case 'C'                  
                    % ����������
                case 'mu'
                    % ���¼���Hessian��
                    [ H ] = GetHessian(Q, P, TaskNum, params);
                case 'p1'
                    % ���´������p1
                    [ Q, P, A ] = Prepare(X, Y, T, TaskNum, params);
                    [ H ] = GetHessian(Q, P, TaskNum, params);
                otherwise
                    throw(MException('MTL:MTLS_SVM', 'no parameter changed'));
            end
        else
            % ��һ��������Ҫ���³�ʼ��
            [ Q, P, A ] = Prepare(X, Y, T, TaskNum, params);
            [ H ] = GetHessian(Q, P, TaskNum, params);
        end
        % ���ģ��
        [ Alpha, b ] = Primal(H, A, TaskNum, params);
        [ Time(i, 1) ] = toc;
        % Ԥ��
        [ yTest{i} ] = Predict(xTest, X, Y, TaskNum, T, Alpha, b, params);
    end
else
    tic;
    [ Q, P, A ] = Prepare(X, Y, T, TaskNum, opts);
    [ H ] = GetHessian(Q, P, TaskNum, opts);
    [ Alpha, b ] = Primal(H, A, TaskNum, opts);
    Time = toc;
    [ yTest ] = Predict(xTest, X, Y, TaskNum, T, Alpha, b, opts);
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.lambda ~= p2.lambda
            change = 'mu';
            step = length(opts.lambda);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(IParams.kernel.p1);
                else
                    throw(MException('MTL:MTLS_SVM', 'Change: no parameter changed'));
                end
            else 
                throw(MException('MTL:MTLS_SVM', 'Change: no parameter changed'));
            end
        end
    end

    function  [ Q, P, A ] = Prepare(X, Y, T, TaskNum, opts)
        Q = Y.*Kernel(X, X, opts.kernel).*Y';
        P = sparse(0, 0);
        A = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
            A = blkdiag(A, Y(Tt,:));
        end
    end

    function [ H ] = GetHessian(Q, P, TaskNum, opts)
        H = Q + TaskNum/opts.lambda*P;
    end

    function [ Alpha, b ] = Primal(H, A, TaskNum, opts)
        o = zeros(TaskNum, 1);
        O = speye(TaskNum)*0;
        I = speye(size(H));
        E = ones(size(H, 1), 1);
        G = H + I/opts.C;
        G = [O A';A G];
        y = [o; E];
        bAlpha = G\y;
        Alpha = bAlpha(TaskNum+1:end,:);
        b = bAlpha(1:TaskNum,:);        
    end

    function [ yTest ] = Predict(xTest, X, Y, TaskNum, T, Alpha, b, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = Predict(Ht, Y, Alpha);
            yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(y0 + TaskNum/opts.lambda*yt + b(t));
            y(y==0) = 1;
            yTest{t} = y;
        end

            function [ y ] = Predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi).*Alpha(svi));
            end
    end

end
