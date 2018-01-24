function [accuracy,t]=KerSVM(tstX,tstY,X,Y,C,p1)
    opts=[];
    [L,~]=size(X);

    % �˾���
    K1 = exp(-(repmat(sum(X.*X,2)',L,1)+repmat(sum(X.*X,2),1,L)-2*(X*X'))/(2*p1^2));
    H = diag(Y)*K1*diag(Y);
    % ��ʱ
    tic
    % ������
    a = -ones(L,1);
    % ���½�
    lb = zeros(L,1);
    ub = C*ones(L,1);
    % ���ι滮���
    [x] = quadprog(H,a,[],[],[],[],lb,ub,[],opts);
    % ֹͣ��ʱ
    t = toc;

    [s,~] = size(tstX);
    % �˾���
    KT = exp(-(repmat(sum(tstX.*tstX,2)',L,1)+repmat(sum(X.*X,2),1,s) - 2*X*tstX')/(2*p1^2)); KT = KT';
    % f(x) = kernel(x, x) * Y * X
    PY = KT*diag(Y)*x;
    % Ԥ��ֵ
    pre = sign(PY);
    % Ԥ��ֵΪ0�ĸ�Ϊ1
    pre(pre==0)=1;
    % ���㾫ȷ��
    accuracy=mean(pre==tstY);
end


