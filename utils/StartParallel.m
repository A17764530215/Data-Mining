function [ ] = StartParallel(size)
%STARTPARELLEL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
                display(strcat('����size����ȷ������Ĭ�����ã�size=',num2str(size)));
            end
        end
    else
        fprintf('matlabpool �Ѿ�����');
        if nargin==1
            if nlabs~=size
                parpool close;
                startmatlabpool(size);
            end
        end
    end
end