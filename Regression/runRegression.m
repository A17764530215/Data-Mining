images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabIParams.mat');
load('Colors.mat', 'Colors');

% run regression
kernel = struct('kernel', 'rbf', 'p1', 36.2);

% C1 = 1; C2 = 1; C3 = 1; C4 = 1;
% eps1 = 0.4; eps2 = 0.4;
% opts1 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
% opts2 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
% opts3 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
% opts4 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
solver = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

opts = {opts1, opts2, opts3, opts4};

perf = zeros(4, 5, 4);
% h = figure('Visible', 'on');
% ��ÿһ�����ݼ�
for i = [3 4]
    DataSet = LabUCIReg(i);
    [X, Y, ~] = MultiTask(DataSet, 4, 5);
%     [X, Y] = Normalize(X, Y);
    % ��ÿһ��MTL����
    for j = 1 : 4
        % ������ѧϰ
        opt = opts{j};
        opt.solver = solver;
        [ y, Time] = MTL(X, Y, X, opt);
%         clf(h);
        % ���ƶ�����ѧϰ���
        perf(j, 5, i) = Time;
        for t = 1 : 4
            perf(j, t, i) = mse(y{t}-Y{t});
%             PlotCurve( X{t}, Y{t}, ['Task-', num2str(t)], 2, 2, t, 1, Colors(1,:));
%             PlotCurve( X{t}, y{t}, ['Task-', num2str(t)], 2, 2, t, 2, Colors(2,:));
        end
        % ����ͼƬ
%         name = ['runRegression-', DataSet.Name, '-', opt.Name];
%         saveas(h, [images, name, '.png']);
%         savefig(h, [images, name]);
    end
end