clc
clear

addpath(genpath('./utils/'));

% 网格搜索参数
C = 2.^(-3:1:8)';
C3 = 1e-7;% cond 矫正
EPS = [0.01;0.02;0.05;0.1];
RHO = 2.^(-3:1:8)';
MU = (0.1:0.1:1)';
ETA =(0:0.1:1)';
% MTL-aLS-SVM
RATE = [0.83,0.90,0.97]';
% MTCTSVM
P = (0.5:0.5:2.0)';
% VSTG-MTL
K = (3:2:13)';
k = (1:2:7)';

%% 核函数参数
P1 = 2.^(-3:8)'; % 核函数参数
[ linear ] = PackKernel('Linear');
[ poly ] = PackKernel('Poly', 2);
[ rbf ] = PackKernel('RBF', P1);

%% 回归器参数
RParams = cell(3, 1);
[ RParams{1} ] = PackRParams(C, EPS, RHO, linear);
[ RParams{2} ] = PackRParams(C, EPS, RHO, poly);
[ RParams{3} ] = PackRParams(C, EPS, RHO, rbf);
RParams = cellcat(RParams, 1);
[ RParams ] = PrintParams('./params/LabRParams.txt', RParams);
save('./params/LabRParams.mat', 'RParams');

%% 分类器参数
CParams = cell(3, 1);
[ CParams{1} ] = PackCParams(C, RHO, MU, ETA, P, RATE, linear);
[ CParams{2} ] = PackCParams(C, RHO, MU, ETA, P, RATE, poly);
[ CParams{3} ] = PackCParams(C, RHO, MU, ETA, P, RATE, rbf);
CParams = cellcat(CParams, 1);
[ CParams ] = PrintParams('./params/LabCParams.txt', CParams);
save('./params/LabCParams.mat', 'CParams');

%% 安全筛选参数
[ linear0 ] = PackKernel('Linear');
[ poly0 ] = PackKernel('Poly', 2);
[ rbf0 ] = PackKernel('RBF', 64);
SParams = cell(3, 1);
% [ SParams{1} ] = PackSParams(10.^(0:0.02:1)', 10.^(-1:0.2:1)', linear0);
% [ SParams{2} ] = PackSParams(10.^(0:0.02:1)', 10.^(-1:0.2:1)', poly0);
% [ SParams{3} ] = PackSParams(10.^(0:0.02:1)', 10.^(-1:0.2:1)', rbf0);
% for all datasets
% [ SParams{1} ] = PackSParams(10.^(0:0.015:1)', 10.^(-1:0.2:1)', linear0);
% [ SParams{2} ] = PackSParams(10.^(0:0.015:1)', 10.^(-1:0.2:1)', poly0);
% [ SParams{3} ] = PackSParams(10.^(0:0.015:1)', 10.^(-1:0.2:1)', rbf0);
% 2019年4月2日09:17:16
% [ SParams{1} ] = PackSParams(2.^(2:0.05:7)', 2.^(-6:6)', linear0);
% [ SParams{2} ] = PackSParams(2.^(2:0.05:7)', 2.^(-6:6)', poly0);
% [ SParams{3} ] = PackSParams(2.^(2:0.05:7)', 2.^(-6:6)', rbf0);
% 2019年4月2日23:04:28
[ SParams{1} ] = PackSParams(2.^(0:0.03:5)', 2.^(-4:4)', linear0);
[ SParams{2} ] = PackSParams(2.^(0:0.03:5)', 2.^(-4:4)', poly0);
[ SParams{3} ] = PackSParams(2.^(0:0.03:5)', 2.^(-4:4)', rbf0);
SParams = cellcat(SParams, 1);
[ SParams ] = PrintParams('./params/LabSParams.txt', SParams);
[ IParams ] = CreateParams(SParams{2});
save( './params/LabSParams.mat', 'SParams');
%%
A=10.^(0:0.02:2)';
B=2.^(0:0.05:5)';
a = A(2:end)-A(1:end-1);
b = B(2:end)-B(1:end-1);
%%

%% 核参数
function [ kernel ] = PackKernel(name, p1)
    switch name
        case 'Linear'
            kernel = struct('type', 'linear');
        case 'Poly'
            kernel = struct('type', 'poly', 'p1', p1);
        otherwise
            kernel = struct('type', 'rbf', 'p1', p1);
    end
end

%% 回归参数
function [ RParams ] = PackRParams(C, EPS, RHO, kernel)
    RParams = {
        struct('Name', 'SVR', 'C', C, 'eps', EPS, 'kernel', kernel);...
        struct('Name', 'PSVR', 'C', C, 'kernel', kernel);...
        struct('Name', 'LS_SVR', 'C', C, 'kernel', kernel);...
        struct('Name', 'TWSVR', 'C1', C, 'C3', C, 'eps1', EPS, 'kernel', kernel);... 
        struct('Name', 'TWSVR_Xu', 'C1', C, 'eps1', EPS, 'kernel', kernel);...
        struct('Name', 'LSTWSVR_Mei', 'C1', C, 'eps1', EPS, 'kernel', kernel);...
        struct('Name', 'LSTWSVR_Huang', 'eps1', EPS, 'kernel', kernel);...
        struct('Name', 'MTLS_SVR', 'lambda', RHO, 'C', C, 'kernel', kernel);...
        struct('Name', 'MTPSVR', 'lambda', RHO, 'C', C, 'kernel', kernel);...
        struct('Name', 'MTL_TWSVR', 'C1', C, 'eps1', EPS, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'MTL_TWSVR_Xu', 'C1', C, 'eps1', EPS, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'MTLS_TWSVR', 'C1', C, 'eps1', EPS, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'LSTWSVR_Xu', 'C1', C, 'eps1', EPS, 'kernel', kernel);...
        struct('Name', 'MTLS_TWSVR_Xu', 'C1', C, 'eps1', EPS, 'rho', RHO, 'kernel', kernel)...
    };
    for  i = 1 : length(RParams)
        RParams{i}.ID = RParams{i}.Name;
    end
end

%% 分类参数
function [ CParams ] = PackCParams(C, RHO, MU, ETA, P, RATE, kernel)
    CParams = {
        struct('Name', 'SVM', 'C', C, 'kernel', kernel);...
        struct('Name', 'PSVM', 'C', C, 'kernel', kernel);...
        struct('Name', 'LS_SVM', 'C', C, 'kernel', kernel);...
        struct('Name', 'TWSVM', 'C1', C, 'kernel', kernel);...
        struct('Name', 'LSTWSVM', 'C1', C, 'kernel', kernel);...
        struct('Name', 'vTWSVM', 'v1', MU, 'kernel', kernel);...
        struct('Name', 'ITWSVM', 'C1', C, 'C3', C, 'kernel', kernel);...
        struct('Name', 'RMTL', 'lambda1', RHO, 'lambda2', RHO, 'kernel', kernel);...
        struct('Name', 'MTPSVM', 'lambda', RHO, 'C', C, 'kernel', kernel);...
        struct('Name', 'MTLS_SVM', 'lambda', RHO, 'C', C, 'kernel', kernel);...
        struct('Name', 'MTL_aLS_SVM', 'C1', C, 'C2', C, 'rho', RATE, 'kernel', kernel);...
        struct('Name', 'DMTSVM', 'C1', C, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'MCTSVM', 'C1', C, 'rho', RHO, 'p', P, 'kernel', kernel);...
        struct('Name', 'MTLS_TWSVM', 'C1', C, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'MTvTWSVM', 'v1', MU, 'rho', RHO, 'kernel', kernel);...
        struct('Name', 'MTvTWSVM2', 'v1', MU, 'rho', ETA, 'kernel', kernel);...
    };
    for  i = 1 : length(CParams)
        CParams{i}.ID = CParams{i}.Name;
    end
end

%% 安全筛选参数
function [ SParams ] = PackSParams(C, MU, kernel)
    SParams = {
        struct('ID', 'IRMTL_C', 'Name', 'IRMTL', 'C', C, 'mu', MU, 'kernel', kernel);...
        struct('ID', 'SSRC_IRMTL', 'Name', 'SSR_IRMTL', 'C', C, 'mu', MU, 'kernel', kernel);...
        struct('ID', 'IRMTL_M', 'Name', 'IRMTL', 'mu', MU, 'C', C, 'kernel', kernel);...
        struct('ID', 'SSRM_IRMTL', 'Name', 'SSR_IRMTL', 'mu', MU, 'C', C, 'kernel', kernel);...
        struct('ID', 'SVM', 'Name', 'SVM', 'C', C, 'kernel', kernel);...
        struct('ID', 'PSVM', 'Name', 'PSVM', 'C', C, 'kernel', kernel);...
        struct('ID', 'LS_SVM', 'Name', 'LS_SVM', 'C', C, 'kernel', kernel);...
        struct('ID', 'MTPSVM', 'Name', 'MTPSVM', 'C', C, 'lambda', MU, 'kernel', kernel);...
        struct('ID', 'MTLS_SVM', 'Name', 'MTLS_SVM', 'C', C, 'lambda', MU, 'kernel', kernel);...
    };
end