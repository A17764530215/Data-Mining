function [ opts ] = InitOptions( name, cv, mean, solver, hasfig, version)
%INITOPIONS �˴���ʾ�йش˺�����ժҪ
% ��ʼ������
%   �˴���ʾ��ϸ˵��

    opts.cv = cv;
    switch name
        case 'reg'
            opts.Mean = mean;
            opts.Statistics = @RegStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @min;
            opts.Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
        case 'clf'
            opts.Mean = mean;
            opts.Statistics = @ClfStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
        case 'mcl'
            opts.Mean = mean;
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
    end    
    
    if nargin > 5
        if version == 1
            % ��һ��ֻͳ����Accuracy
            opts.IndexCount = 1;
            opts.Indices = {'Accuracy', 'Std1'};
        elseif version == 2
            % �ڶ��潻����Precision��Recall˳��
            opts.IndexCount = 4;
            opts.Indices = opts.Indices([1, 3, 2, 4]);                
        elseif version == 3
            opts.IndexCount = 4;
            if opts.cv
                opts.Indices = cat(2, opts.Indices, 'Std1', 'Std2', 'Std3', 'Std4');                
            end
        end
    end
    
end