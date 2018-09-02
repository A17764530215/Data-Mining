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
    [nParams, IDX] = sort(nParams);
    IParams = IParams(IDX);
    % ���Ի�ȡ������ʱ��
    fd = fopen(Path, 'w');
    for i = 1 : n
        Method = IParams{i};
        tic
        GetParams(Method, 1);
        Time = toc;
        fprintf(fd, '%s:%d params %.2fs.\n', Method.Name, nParams(i, 1), nParams(i, 1)*Time);
    end
    fclose(fd);
end