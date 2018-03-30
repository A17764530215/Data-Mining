function [ Output ] = GridSearchCV( Learner, X, Y, Kfold, ValInd, IParams, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 网格搜索交叉验证
%   此处显示详细说明
% 参数：
%   Learner    -分类器
%         X    -样本
%         Y    -标签
%    Params    -参数网格
%     Kfold    -K折交叉验证
% 输出：
%    Output    -网格搜索、交叉验证结果

    % 得到参数组数
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    % 对每一组参数
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        % 交叉验证
        opts.Params = IParams(i);
        [ Accuracy, Precision, Recall, Time ] = CrossValid(Learner, X, Y, ValInd, Kfold, opts);
        % 保存结果
        Output(i, :) = [Accuracy Precision Recall Time];
    end
end