function [ ] = run(X, Y, ker, C, file)
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
    clf = SVM(ker, C, 12);
    % ѵ��ģ��
    clf = clf.Fit(X, Y);
    % �ڲ��Լ��ϲ���
    [clf, y] = clf.Predict(x);
    svX = X(clf.svi,:);
    % ����ͼ��
    h = figure('Visible','on');
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