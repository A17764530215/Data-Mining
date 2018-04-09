images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabParams.mat');
load('Colors.mat', 'Colors');

TaskNum = 4;
Kfold = 3;
DataSet = LabUCIReg(2);
[X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
Stat = zeros(7, 4, TaskNum);
% ��ÿһ��MTL����
for j = [ 2 3 4 ]
    % ������ѧϰ
    opt = opts{j};
    opt.solver = solver;
    [X, Y] = Normalize(X, Y);
    Stat(j,:,:) = CrossValid( @MTL, X, Y, TaskNum, Kfold, ValInd, opt );
end