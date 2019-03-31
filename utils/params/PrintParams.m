function [ IParams ] = PrintParams( Path, IParams )
%PRINTPARAMS 此处显示有关此函数的摘要
% 输出参数表信息
%   此处显示详细说明

    % 对参数表排序
    n = length(IParams);
    nParams = zeros(n, 1);
    for i = 1 : n
        nParams(i, 1) = GetParamsCount(IParams{i});
    end
    % 测试获取参数的时间
    fd = fopen(Path, 'w');
    info = sprintf('%-12s%-16s%-5s\t%s\n', 'kernel', 'Method.ID', 'nParams', 'Time');
    fprintf(fd, info);
    fprintf(info);
    for i = 1 : n
        Method = IParams{i};
        kernel = Method.kernel;
        tic
        GetParams(Method, 1);
        Time = toc;
        info = sprintf('%-12s%-16s%-5d\t%.2f\n', kernel.type, Method.ID, nParams(i, 1), nParams(i, 1)*Time);
        fprintf(fd, info);
        fprintf(info)
    end
    fclose(fd);
end