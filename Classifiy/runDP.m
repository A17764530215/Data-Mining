images = '../images/ComparativeDensityPeaks/';
logPath = './log.txt';

% ���ݼ�
DataSets = Artificial;
% ��ͼ
h = figure();
% ���ݼ�
for i = [1 2 4]
    DataSet = DataSets(i);
    Data = DataLabel(DataSet.Data, DataSet.LabelColumn);
    Name = DataSet.Name;
    nCluster = DataSet.Classes;
    [ X, Y ] = SplitDataLabel(Data);
    % �ܶȷ�ֵ����
%     [ C, ~, Rho, Delta, Gamma, idx, DeltaTree, Halo, nCore, nHalo ] = DP( X, nCluster );
%     [ C, ~, Rho, Delta, Tau, Gamma, idx, DeltaTree ] = CDP( X, Y, nCluster, false );
    [ C, V, Gamma, k ] = KNNSTWSVM.Clustering(X, pi/6);
    fprintf('%s Has %d clusters.\n', Name, k);
    % ���Ʀ�-��ɢ��ͼ
%     clf(h);
%     S = [ Rho, Delta, Y ];
%     V = S(idx, :);
%     PlotMultiClass(S, Name, 1, 1, 1, 6, Colors);
%     PlotMultiClass(V, Name, 1, 1, 1, 32, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-RhoDelta', '.png']);
    % ����DeltaTree
%     clf(h);
%     PlotTree(X, DeltaTree, Rho);
%     PlotMultiClass(Data, Name, 1, 1, 1, 6, Colors);
%     PlotMultiClass(Data(idx, :), Name, 1, 1, 1, 32, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-DeltaTree', '.png']);
    % ���Ʀ�����
    clf(h);
    [ gamma_sorted, gamma_idx ] = sort(Gamma, 'descend');
    Gx = (1:DataSet.Instances-2).';
    G = [ Gx, gamma_sorted, Y(gamma_idx) ];
    Gr = G(1:15, :);
    scatter(Gr(:,1), Gr(:,2), 12, '.b');
    hold on
    scatter(Gr(1:nCluster,1), Gr(1:nCluster,2), 96, '.b');
    saveas(h, [images, 'runCDP-', Name, '-Gamma', '.png']);
    % ����ԭʼ����
%     clf(h);
%     PlotMultiClass(Data, Name, 1, 1, 1, 3, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-Initial', '.png']);
    % ���ƾ�����
    clf(h);
    PlotMultiClass([X, C], Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, 'runCDP-', Name, '-Result', '.png']);
    % ����Halo
    % clf(h);
%     PlotMultiClass(DC(Halo==0, :), Name, 1, 1, 1, 3, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-Halo', '.png']);
%     ����ѡ��
    [Xr, Yr, W] = LDP(X, Y, nCluster, 0.5);
%     ��������ѡ����
    clf(h);
    PlotMultiClass([Xr, Yr], Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, 'runCDP-', Name, '-Selection', '.png']);
end