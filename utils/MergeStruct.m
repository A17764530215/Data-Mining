function [ C ] = MergeStruct( A, B )
%MERGESTRUCT �˴���ʾ�йش˺�����ժҪ
% �ϲ��ṹ��
%   �˴���ʾ��ϸ˵��

    namesa = fieldnames(A);
    namesb = fieldnames(B);
    for i = 1 : length(namesa)
        C.(namesa{i}) = A.(namesa{i});
    end
    for i = 1 : length(namesb)
        C.(namesb{i}) = B.(namesb{i});
    end
end