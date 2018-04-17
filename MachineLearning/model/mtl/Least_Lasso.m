%% Sparse Structure-Regularized Learning with Least Squares Loss.
function [ W, funcVal ] = Least_Lasso( X, Y, GradEval, FuncEval, l1_projection, opts )
%LEAST_LASSO �˴���ʾ�йش˺�����ժҪ
% 4.1.1 Multi-Task Lasso with Least Squares Loss (Least Lasso)
%   �˴���ʾ��ϸ˵��

    if nargin <3
        error('\n Inputs: X, Y, abd rho1 should be specified!\n');
    end

    if nargin <4
        opts = [];
    end

    % initialize options.
    opts=init_opts(opts);

    if isfield(opts, 'rho1')
        rho1 = opts.rho1;
    else
        rho1 = 0;
    end

    task_num  = length (X);
    dimension = size(X{1}, 1);
    funcVal = [];

    XY = cell(task_num, 1);
    W0_prep = [];
    for t_idx = 1: task_num
        XY{t_idx} = X{t_idx}*Y{t_idx};
        W0_prep = cat(2, W0_prep, XY{t_idx});
    end

    % initialize a starting point
    if opts.init==2
        W0 = zeros(dimension, task_num);
    elseif opts.init == 0
        W0 = W0_prep;
    else
        if isfield(opts,'W0')
            W0=opts.W0;
            if (nnz(size(W0)-[dimension, task_num]))
                error('\n Check the input .W0');
            end
        else
            W0=W0_prep;
        end
    end

    bFlag=0; % this flag tests whether the gradient step only changes a little

    Wz= W0;
    Wz_old = W0;

    t = 1;
    t_old = 0;


    iter = 0;
    gamma = 1;
    gamma_inc = 2;

    while iter < opts.maxIter
        alpha = (t_old - 1) /t;

        % Ws��Wz��Wz_old����ϣ�s����smooth�����������ֵĽ�W
        Ws = (1 + alpha) * Wz - alpha * Wz_old;

        % compute function value and gradients of the search point
        gWs = GradEval(Ws);
        Fs  = FuncEval(Ws);

        while true
            % ���ݶ�ͶӰ������ݶȺ�W��L1����
            [Wzp, l1c_wzp] = l1_projection(Ws - gWs/gamma, 2 * rho1 / gamma);
            % ���������ֵĺ���ֵ
            Fzp = FuncEval(Wzp);
            % ����W�ı仯
            delta_Wzp = Wzp - Ws;
            r_sum = norm(delta_Wzp, 'fro')^2;
            % ����������
            Fzp_gamma = Fs + sum(sum(delta_Wzp .* gWs)) + gamma/2 * sum(sum(delta_Wzp.*delta_Wzp));
            % W��2�����仯��С���˳�
            if (r_sum <=1e-20)
                bFlag=1; % this shows that, the gradient step makes little improvement
                break;
            end
            % �������������ֵFzp_gamma�������ֵFzp
            if (Fzp <= Fzp_gamma)
                break;
            else
                gamma = gamma * gamma_inc;
            end
        end

        Wz_old = Wz;
        Wz = Wzp;

        % ��¼����ֵ��������
        funcVal = cat(1, funcVal, Fzp + rho1 * l1c_wzp);

        if (bFlag)
            % fprintf('\n The program terminates as the gradient step changes the solution very small.');
            break;
        end

        % test stop condition.
        switch(opts.tFlag)
            case 0
                if iter>=2
                    if (abs( funcVal(end) - funcVal(end-1) ) <= opts.tol)
                        break;
                    end
                end
            case 1
                if iter>=2
                    if (abs( funcVal(end) - funcVal(end-1) ) <=...
                            opts.tol* funcVal(end-1))
                        break;
                    end
                end
            case 2
                if ( funcVal(end)<= opts.tol)
                    break;
                end
            case 3
                if iter>=opts.maxIter
                    break;
                end
        end

        iter = iter + 1;
        t_old = t;
        t = 0.5 * (1 + (1+ 4 * t^2)^0.5);

    end

    W = Wzp;

end

