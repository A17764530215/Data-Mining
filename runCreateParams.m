addpath(genpath('./utils/'));

% �˺�������
P1 = 2.^(-3:1:8)';
% ������������������
C = 2.^(-3:1:8)';
C1 = 2.^(-3:1:8)';
C2 = 2.^(-3:1:8)';
C3 = 1e-7;% cond ����
C4 = 1e-7;% cond ����
EPS1 = [0.01;0.02;0.05;0.1];
EPS2 = [0.01;0.02;0.05;0.1];
RHO = 2.^(-3:1:8)';
LAMBDA = 2.^(-3:1:8)';
GAMMA = 2.^(-3:1:8)';
NU = 2.^(-3:1:8)';

% �˺���
% kernel = struct('kernel', 'rbf', 'p1', P1);
kernel = struct('kernel', 'linear');
% �������
IParams = {
    struct('Name', 'SVR', 'C', C, 'eps', EPS1, 'kernel', kernel);...
    struct('Name', 'PSVR', 'nu', NU, 'kernel', kernel);...
    struct('Name', 'LS_SVR', 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'TWSVR', 'C1', C1, 'C3', C3, 'eps1', EPS1, 'kernel', kernel);... 
    struct('Name', 'TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Mei', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Huang', 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'MTL_LS_SVR', 'lambda', LAMBDA, 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'MTL_PSVR', 'lambda', LAMBDA, 'nu', NU, 'kernel', kernel);...
    struct('Name', 'MTL_TWSVR', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MTL_LS_TWSVR', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'MTL_LS_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel)
};

% �����������Ϣ
n = length(IParams);
nParams = zeros(n, 1);
for i = 1 : n
    nParams(i, 1) = GetParamsCount(IParams{i});
    Method = IParams{i};
    tic
    Params = GetParams(Method, 1);
    Time = toc;
    fprintf('%s:%d params %.2fs.\n', Method.Name, nParams(i, 1), nParams(i, 1)*Time);
end

[~, IDX] = sort(nParams);
IParams = IParams(IDX);
% ���������
save('./params/LabIParams-Linear.mat', 'IParams');