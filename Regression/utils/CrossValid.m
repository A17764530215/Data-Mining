function [ Results ] = CrossValid( Learner, X, Y, Params, opts )
%CROSSVALID �˴���ʾ�йش˺�����ժҪ
% k�۽�����֤
%   �˴���ʾ��ϸ˵��
% ������
%  Learner    -ѧϰ�㷨
%        X    -����
%        Y    -��ǩ
%   Params    -ѧϰ������
%     opts    -������֤����
% �����
%     
%     Time    -ƽ��ѵ��ʱ��


%% Cross Validation
    Times = zeros(1, Kfold);
    Stats = zeros(Kfold, 4);
    Results = 
    Output = mean(Stats);
    Time = mean(Times);
end