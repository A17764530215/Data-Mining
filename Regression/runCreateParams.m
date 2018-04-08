addpath(genpath('./utils'));

% �˺�������
RangeP1 = 2.^(1:3:10)';
kernel = struct('kernel', 'rbf', 'p1', RangeP1);
% ������������������
C = 2.^(1:2:9)';
C1 = 2.^(1:2:9)';
C2 = 2.^(1:2:9)';
C3 = 2.^(1:2:9)';
C4 = 2.^(1:2:9)';
EPS1 = 2.^(1:2:9)';
EPS2 = 2.^(1:2:9)';
RHO = 2.^(1:3:10)';
LAMBDA = 2.^(1:3:10)';
GAMMA = 2.^(1:3:10)';
% �������
Params1 = struct('Name', 'PSVR', 'nu', C1, 'kernel', kernel);
Params2 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', EPS1, 'eps2', EPS2, 'kernel', kernel);
Params3 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'kernel', kernel);
Params4 = struct('Name', 'MTL_LS_SVR', 'lambda', LAMBDA, 'gamma', GAMMA, 'kernel', kernel);
Params5 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'kernel', kernel);
Params6 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'kernel', kernel);
Params7 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'rho', RHO, 'lambda', LAMBDA, 'kernel', kernel);
% ת��������
OParams = {Params1;Params2;Params3;Params4;Params5;Params6;Params7};
nParams = length(OParams);
for i = 1 : nParams
    % ��ʼ��������
    fprintf('Params\n')
    IParams{i, 1} = CreateParams(OParams{i});
end

% ���������
save('LabIParams.mat', IParams);