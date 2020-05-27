function [ yTest, Time ] = FSVM(xTrain, yTrain, xTest, opts)
%Field SVM �˴���ʾ�йش����ժҪ
% Kernel Support Vector Machine
%   �˴���ʾ��ϸ˵��
    
    % ���÷���������
    C = opts.C;
    T = opts.T;
    TaskNum = opts.TaskNum;
    kernel = opts.kernel;
    
    [ X, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    [m, ~] = size(X);
    e = ones(m, 1);
    Anew = SNTFit(X, Y, T, TaskNum);
    [ xTest ] = SNT(xTest, A, T, TaskNum)
    [ yTest ] = Predict(Alpha);
    % ֹͣ��ʱ
    Time = toc;
    
    function [ Anew ] = SNTFit(xTrain, yTrain, zTrain, T)
        [~, n] = size(xTrain);
        % ����A����
        Aold = ones(n, n, T);
        Anew = ones(n, n, T);
        for i = 1 : T
            Anew(:,:,i) = diag(ones(1, n));
            Aold = Anew;
        end
        % �������CSVM-Style Normalization Transformation (SNT)
        while (true)
            % 1. SNT ��ʽ�淶��ת��
            [ xTrain ] = SNT(xTrain, A, T, TaskNum);
            % 2. CSVM Learning ��ת�����������ѵ��
            [ W, Alpha ] = Fit(xTrain, yTrain, C);
            % 3. SNT ѧϰ. ���ݹ�ʽ(5)���±任����A
            for i = 1 : T
                Tt = T==i; % ���ݹ�ʽ(5)���±任����Ai
                Wi = GetW(xTrain(Tt,:), yTrain(Tt,:), Alpha(Tt,:));
                Anew(:,:,i) = W*Wi'/(2*T);
            end
            % 4. Check Convergence.  ���ѧ����SNT�仯���󣬾��˳�
            if norm(Anew-Aold, 'fro') > 0.0001
                Aold = Anew;
            else
                break;
            end
        end
    end

    function [ xTrain ] = SNT(xTrain, A, T, TaskNum)
       % SNT
        for i = 1 : TaskNum
            xTrain(T==i,:) = A(:,:,i)*xTrain(T==i,:);
        end
    end

    function [ W, Alpha ] = Fit(xTrain, yTrain, C)
        K = Kernel(xTrain, xTrain, kernel);
        H = Cond(diag(yTrain)*K*diag(yTrain));
        Alpha = quadprog(H, -e, [], [], [], [], zeros(m, 1), C*e, [], []);
        svi = Alpha > 0;
        W = K(svi:svi)*diag(yTrain(svi))*Alpha(svi);
    end

    function [ yTest ] = Predict(Alpha)
        K = Kernel(xTest, xTrain, kernel);
        yTest = sign(K*diag(yTrain)*Alpha);
        yTest(yTest==0) = 1;
    end

end