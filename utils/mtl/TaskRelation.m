function [ R ] = TaskRelation( W )
%TASKRALATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    R = corrcoef(cell2mat(W'));
    
end