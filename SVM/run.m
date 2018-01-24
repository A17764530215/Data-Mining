function [ ] = run(X, Y, ker, C, file)
    % ѵ��ģ��
    [m, n]=size(X);
    fprintf('size X = [%d, %d]\n', m, n);
    % ѵ��ģ��
    [ nsv, alpha, b0 ] = svc( X, Y, ker, C );
    % ���֧����������
    fprintf('svi: %d\n', nsv);
    % ����alpha����w
    epsilon = 10e-6;
    svi = alpha(:,1) > epsilon;
    svAlpha = alpha(svi,1);
    svX = X(svi,:);
    svY = Y(svi,:);
    % ����������ݼ�
    x = zeros(961, 2);
    for i = 1:1:30
        for j = 1:1:30
            xi = -3.0 + i*0.2;
            xj = -3.0 + j*0.6;
            xij = zeros(1, 2);
            xij(1, 1:2) = [xi xj];
            x(30 * i + j,:) = xij;
        end
    end
    % ���x, y����Ϣ
    [m, n] = size(x);
    fprintf('size x = [%d, %d]\n', m, n);
    % �ڲ��Լ��ϲ���
    b = repmat(b0, 1, m);
    y = sign(sum(svAlpha.*svY.*kernel(ker, svX, x)) + b);
    [m, n] = size(y);
    fprintf('size y = [%d, %d]\n', m, n);
    % ����ͼ��
    h = figure('Visible','off');
    % ���Ʋ������ݵ�
    xp = x(y==1,:);
    scatter(xp(:,1), xp(:,2), 1, 'r');
    hold on;
    xn = x(y==-1,:);
    scatter(xn(:,1), xn(:,2), 1, 'b');
    hold on;
    % �����������
    XP = X(Y==1,:);
    scatter(XP(:,1), XP(:,2), 12, 'rx');
    hold on;
    XN = X(Y==-1,:);
    scatter(XN(:,1), XN(:,2), 12, 'bo');
    hold on;
    % ����֧������
    scatter(svX(:,1), svX(:,2), 36, 'kO');
    % ����������
    title('SVM');
    xlabel('X');    
    ylabel('Y');
    % ����ͼƬ
    saveas(h, file);
end