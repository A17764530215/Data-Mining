function [ opts ] = InitOptions( name, solver)
%INITOPIONS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    switch name
        case 'reg'
            opts.Statistics = @RegStat;
            opts.IndexCount = 4;
            opts.solver = solver;
            opts.Find = @min;
        case 'clf'
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
            opts.Find = @max;
        case 'mcl'
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
            opts.Find = @max;
    end
end

