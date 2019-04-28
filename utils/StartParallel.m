function [ ] = StartParallel(size)
%STARTPARELLEL 此处显示有关此函数的摘要
%   此处显示详细说明
    isstart = 0;
    nlabs = parpool('size');
    if nlabs==0
        isstart = 1;
    end
    if isstart==1
        if nargin==0
            parpool('open','local');
        else
            try
                parpool('open','local',size);
            catch ce
                parpool('open','local');
                size = parpool('size');            
                display(ce.message);
                display(strcat('输入size不正确，采用默认配置，size=',num2str(size)));
            end
        end
    else
        fprintf('matlabpool 已经启动');
        if nargin==1
            if nlabs~=size
                parpool close;
                startmatlabpool(size);
            end
        end
    end
end