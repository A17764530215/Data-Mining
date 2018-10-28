function [ Stat ] = ClfStat(y, yTest)
%CLFSTAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    TP = sum(yTest(y==1)==1);
    FN = sum(yTest(y==1)==0);
    FP = sum(yTest(y==0)==1);
    TN = sum(yTest(y==0)==0);
%     Accuracy = mean(y==yTest);
    Precision = TP/(TP+FP);
    Recall = TP/(TP+FN);
    F1 = 2*Precision*Recall/(Precision+Recall);
    Accuracy = (TP+TN)/(TP+TN+FP+FN);
    Stat = [ Accuracy, Precision, Recall, F1 ];
end