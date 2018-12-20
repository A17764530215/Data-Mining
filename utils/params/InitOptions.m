function [ opts ] = InitOptions( name, mean, solver, hasfig, version)
%INITOPIONS �˴���ʾ�йش˺�����ժҪ
% ��ʼ������
%   �˴���ʾ��ϸ˵��

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
    
    if nargin > 4
        if version == 1
            % ��һ��ֻͳ����Accuracy
            opts.Indices = {'Accuracy'};
            opts.IndexCount = 2;
        end
        if version == 2
            % �ڶ��潻����Precision��Recall˳��
            opts.Indices = opts.Indices([1, 3, 2, 4]);
            opts.IndexCount = 8;
        end
        if version == 3
            % ������ֻͳ����ƽ��ֵ��û�б�׼��
            opts.IndexCount = 4;
        end
    end
end