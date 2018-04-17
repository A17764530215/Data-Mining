% �������·��
addpath(genpath('./params'));

% ��ʼ��������
load('LabIParams.mat');
nParams = length(IParams);
for i = 1 : nParams
    nParams = GetParamsCount(IParams{i});
    Method = IParams{i};
    tic
    Params = GetParams(Method, 1);
    Time = toc;
    fprintf('%s:%d params %.2f.\n', Method.Name, nParams, nParams*Time);
end