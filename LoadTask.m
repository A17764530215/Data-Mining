clear
clc
kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/ssr/poly/'];
        load('LabSParams-Poly.mat');
    otherwise
        Src = ['./data/ssr/rbf/'];
        load('LabSParams.mat');
end
addpath(genpath(Src));

load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');

DataSets = [MTL_UCI5; Caltech5; MLC5];
IParams = CreateParams(SParams{5});
Params = struct2cell(IParams)';
Result = cell(54, 1);
State = zeros(54, 9);
Error = zeros(54, 8);
I = [ 1:1296 ];
for i = [ 2:9 1 28:40 ]
    D = DataSets(i);
    A = load(['IRMTL-', D.Name,'.mat']);
    B = load(['SSRC_IRMTL-', D.Name,'.mat']);
    T = mean(A.CVTime(I,:)-B.CVTime(I,:), 1)/mean(A.CVTime(I,1));
    C = permute(A.CVStat(I,1,:)==B.CVStat(I,1,:), [1 3 2]);
    % Result
    IDX = B.CVRate(I,:)>0;
    cnt = sum(IDX, 1);
    avg0 = mean(B.CVRate(I,:), 1);
    avg1 = sum(B.CVRate(I,:), 1)./cnt;
    avg2 = mean(B.CVRate(IDX(:,2),1)./B.CVRate(IDX(:,2),2));
    a = mean([A.CVStat(I,1,:), B.CVStat(I,1,:)], 3);
    b = mean([A.CVStat(I,1,:) - B.CVStat(I,1,:)], 3);
    Result{i} = [a, b, a-b, B.CVRate(I,:), A.CVTime(I,1), B.CVTime(I,1)];
    if mean(C(:)) == 1
        fprintf('Success: %d\n', i);
        State(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, avg1, avg2, T(1)];
    else
        fprintf('Error: %d\n', i);
        Error(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, avg1, T(1)];
    end
end
%%
EE = Result{44,1};
IDX = find(EE(:,2)~=EE(:,1));
ErrorParams = IParams(IDX);
E=EE(IDX,:);
% 