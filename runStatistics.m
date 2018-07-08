Src = './data/regression/rbf/';
Dst = './lab/regression/rbf/';

% �������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% �������ݼ���������������
load('LabMTLReg.mat');
load('LabRParams.mat');

% ʵ������
opts = InitOptions('reg', 1, []);
[ MyStat, MyRank ] = MyStatistics(LabMTLReg, RParams, Src, Dst, opts);
save('MyStat-LabMTLReg.mat', 'MyStat', 'MyRank');