%% MTvTWSVM
clc
clear
load('DATA5.mat');
load('LabCParams.mat');
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
Data = mean(Summary.Data, 3);
[ d ] = GetBestParam(CParams{7}, Data, INDICES, 'rho', 'v1', true);
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');

%% SSRC_IRMTL
clc
clear
load('DATA5.mat');
load('LabSParams.mat');
SParams = reshape(SParams, 14, 3);
figure();
for k = [ 1 3 ]
    for i = [ 8 12 ]
        [ Result ] = GetBestResult('./data/ssr', DataSets, SParams{i,k}, [1],  {'Accuracy'}, {'Selected'}, '\mu', 'C');
        DrawBestResult('./figures/paper3/index', Result, [1], '\mu', 'C');
    end
    for i = [ 10 14 ]
        [ Result ] = GetBestResult('./data/ssr', DataSets, SParams{i,k}, [1],  {'Accuracy'}, {'Selected'}, 'C', '\mu');
        DrawBestResult('./figures/paper3/index', Result, [1], 'C', '\mu');
    end
end

%%
function [ ] = DrawBestResult(Path, Result, IDX, x, y)
    p = Result.Params;
    X = p.(replace(x,'\',''));
    Y = p.(replace(y,'\',''));
    kernel = p.kernel;
    for i  = IDX
        r = Result(i);
        folder = sprintf('%s/%s/%d-fold/', Path, kernel.type, r.Kfold);
        if exist(folder, 'dir') == 0
            mkdir(folder);
        end
        path = sprintf('%s/%s-%s.png', folder, r.Name, p.ID);
        clf;
        % Accuracy
        subplot(1, 2, 1);
        title('Accuracy');
        surf(X, Y, r.BestAccuracy.Z, 'EdgeColor', 'none');view(2);colorbar;
        xlabel(x);
        ylabel(y);
        hold on;
        % Selected
        subplot(1, 2, 2);
        title('Selected');
        surf(X, Y, r.BestScreening.Z, 'EdgeColor', 'none');view(2);colorbar;
        xlabel(x);
        ylabel(y);
        saveas(gcf, path);
    end
end

function [ Result ] = GetBestResult(Path, DataSets, Params, IDX, A, B, x, y)
    kernel = Params.kernel;
    Result = [];
    for i = IDX
        d = DataSets(i);
        folder = sprintf('%s/%s/%d-fold/', Path, kernel.type, d.Kfold);
        File = sprintf('%s/%s-%s.mat', folder, Params.ID, d.Name);
        d = load(File);
        Data = mean(d.CVStat, 3);
        s.BestAccuracy = GetBestParam(Params, Data, A, x, y);
        rate = d.CVRate;
        Data = (rate(:,1)+rate(:,2))./(rate(:,3)+rate(:,4));
        s.BestScreening = GetBestParam(Params, Data, B, x, y);
        s.Name = DataSets(i).Name;
        s.Kfold = DataSets(i).Kfold;
        s.Params = Params;
        Result = cat(1, Result, s);
    end
end