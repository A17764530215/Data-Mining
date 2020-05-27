function [ yTest, Time ] = IRMTL( xTrain, yTrain, xTest, opts )
%IRMTL �˴���ʾ�йش˺�����ժҪ
% Regularized MTL
%   �˴���ʾ��ϸ˵��

TaskNum = length(xTrain);
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
Sym = @(H) (H+H')/2 + 1e-5*speye(size(H));
solver = opts.solver;
opts.solver = [];
opts = rmfield(opts, 'solver');
count = GetParamsCount(opts);
if count > 1
    % ������������
    yTest = cell(count, 1);
    Time = zeros(count, 1);
    [ change, step ] = Change(opts);
    for i = 1 : count
        params = GetParams(opts, i);
        params.solver = solver;
        tic;
        if mod(i, step) ~= 1
            switch change 
                case 'C'
                    % ����������
                case 'mu'
                    % ���¼���Hessian��
                    [ H ] = Sym(Q/params.mu + P);
                case 'p1'
                    % ���¼���Hessian��
                    [ Q, P ] = Prepare(X, Y, T, TaskNum, params.kernel);
                    [ H ] = Sym(Q/params.mu + P);
                otherwise
                    throw(MException('CRMTL', 'no parameter changed'));
            end
        else
            % ���¼���Hessian��
            [ Q, P ] = Prepare(X, Y, T, TaskNum, params.kernel);
            [ H ] = Sym(Q/params.mu + P);
        end
        % ����Ż�ģ��
        [ Alpha ] = Primal(H, params);
        Time(i, 1) = toc;
        % Ԥ��
        [ yTest{i} ] =  Predict(xTest, X, Y, T, Alpha, TaskNum, params);
    end
else
    tic;
    [ Q, P ] = Prepare(X, Y, T, TaskNum, opts.kernel);
    [ H ] = Sym(Q/opts.mu + P);
    [ Alpha ] = Primal(H, opts);
    [ yTest ] = Predict(xTest, X, Y, T, Alpha, TaskNum, opts);
    Time = toc;
end

    function [ change, step ] = Change(opts)
        p1 = GetParams(opts, 1);
        p2 = GetParams(opts, 2);
        if p1.C ~= p2.C
            change = 'C';
            step = length(opts.C);
        elseif p1.mu ~= p2.mu
            change = 'mu';
            step = length(opts.mu);
        else
            k1 = p1.kernel;
            k2 = p2.kernel;
            if strcmp(k1.type, 'rbf') && strcmp(k2.type, 'rbf')
                if k1.p1 ~= k2.p1
                    change = 'p1';
                    step = length(opts.kernel.p1);
                else
                    throw(MException('IRMTL', 'Change: no parameter changed'));
                end
            else 
                throw(MException('IRMTL', 'Change: no parameter changed'));
            end
        end
    end
 
    function [ Alpha ] = Primal(H, opts)
        e = ones(size(H, 1), 1);
        lb = zeros(size(H, 1), 1);
        ub = repmat(opts.C, size(H,1), 1);
        [ Alpha ] = quadprog(H,-e,[],[],[],[],lb,ub,[],opts.solver);
    end

    function  [ Q, P ] = Prepare(X, Y, T, TaskNum, kernel)
        Q = Y.*Kernel(X, X, kernel).*Y';
        P = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            P{t} = Q(Tt,Tt);
        end
        P = spblkdiag(P{:});
    end

    function [ yTest ] = Predict(xTest, X, Y, T, Alpha, TaskNum, opts)
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, opts.kernel);
            y0 = predict(Ht, Y, Alpha);
            yt = predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(y0/opts.mu + yt);
            y(y==0) = 1;
            yTest{t} = y;
        end

            function [ y ] = predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end

end