function [ Stat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 多任务的网格搜索交叉验证
%   此处显示详细说明
% 参数：
%    Learner    -学习器
%          X    -样本
%          Y    -标签
%     Params    -参数网格
%      Kfold    -K折交叉验证
% 输出：
%     Output    -网格搜索、交叉验证结果

    solver = opts.solver;
    nParams = length(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % 网格搜索
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        % 设置参数
        Params = IParams(i);
        Params.solver = solver;
        % 交叉验证
        CVStat(i,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = CVStatistics(TaskNum, CVStat);
    
    function [ OStat ] = CVStatistics(TaskNum, IStat)
        % 交叉验证统计
        OStat = zeros(4, 2, TaskNum);
        % 对每一个任务
        for t = 1 : TaskNum
            % 对每一个统计量
            for k = 1 : 4
                % 找出最小值
                [val, idx] = min(IStat(:,k,t));
                OStat(k,:,t) = [val, idx];
            end
        end
    end
end