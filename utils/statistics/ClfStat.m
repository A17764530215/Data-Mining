function [ Stat ] = ClfStat(y, yTest)
%CLFSTAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    Accuracy = mean(y==yTest);
    Stat = [ Accuracy ];
end

