function [ Output ] = GridSearchCV( Learner, X, Y, IParams, opts )
%GRIDSEARCHCV �˴���ʾ�йش˺�����ժҪ
% ��������������֤
%   �˴���ʾ��ϸ˵��
% ������
%    Learner    -ѧϰ��
%          X    -����
%          Y    -��ǩ
%     Params    -��������
%      Kfold    -K�۽�����֤
% �����
%     Output    -����������������֤���
    
%% Parse opts
    if isfield(opts, 'Kfold')
        Kfold = opts.Kfold;
    else
        throw(MException('CrossValid', 'No Kfold'));
    end
    if isfield(opts, 'ValInd')
        ValInd = opts.ValInd;
    else
        throw(MException('CrossValid', 'No ValInd'));
    end
    
%% Gride Search and Cross Validation
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', j);
            test = (ValInd == j);
            train = ~test;
            [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
        end
    end
end