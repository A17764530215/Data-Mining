function [ Tr ] = BatchReduce(T, mode, k)
%BATCHREDUCE �˴���ʾ�йش˺�����ժҪ
% ���Լ�����ݼ�
%   �˴���ʾ��ϸ˵��
    num = length(T);
    Tr = cell(num, 1);
    if mode == 0
        for t = 1 : num
            m = size(T{t}, 1);
            [ ~, count ] = cellcat(T{t}, 2);
            idx = find(count < 350);
            n = size(idx, 1);
            ids = randperm(n, ceil(m*k));
            Tr{t} = T{t}(idx(ids),:);
        end
    else
        for t = 1 : num
%             m = size(T{t}, 1);
            [ ~, count ] = cellcat(T{t}, 2);
            idx = find(count < 350);
            n = size(idx, 1);
            ids = randperm(n, k);
            Tr{t} = T{t}(idx(ids),:);
        end
    end
end

