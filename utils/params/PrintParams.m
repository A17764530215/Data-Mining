function [ IParams ] = PrintParams( Path, IParams )
%PRINTPARAMS �˴���ʾ�йش˺�����ժҪ
% �����������Ϣ
%   �˴���ʾ��ϸ˵��

    % �Բ���������
    n = length(IParams);
    nParams = zeros(n, 1);
    for i = 1 : n
        nParams(i, 1) = GetParamsCount(IParams{i});
    end
    % ���Ի�ȡ������ʱ��
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