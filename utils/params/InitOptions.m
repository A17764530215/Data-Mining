function [ opts ] = InitOptions( name, solver)
%INITOPIONS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    switch name
        case 'reg'
            opts.Statistics = @RegStat;
            opts.IndexCount = 4;
            opts.solver = solver;
        case 'clf'
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
        case 'mcl'
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
    end
end

