function [ X, Y, C ] = ST2MT(DataSet, i)
%ST2MT �˴���ʾ�йش˺�����ժҪ
% ������ת���������ݼ�
%   �˴���ʾ��ϸ˵��

    [ Data, ~ ] = Preprocess(DataSet.Data, DataSet.AttributeTypes);
    [ X , Y ] = SplitDataLabel(Data, DataSet.Output);
    X = sortrows(X, i);
    % ͳ�Ƶ�i�е�Ƶ���ֲ�
    tab = tabulate(X(:, i));
    cnt = tab(:,2)>0;
    idx = tab(cnt,1);
    idn = tab(cnt,2);
    % ȥ����Ϊ���񻮷ֵĵ�i��
    X(:,i)=  [];
    % ������������ݼ�
    X = mat2cell(X, idn);
    Y = mat2cell(Y, idn);
    C = idx;
end