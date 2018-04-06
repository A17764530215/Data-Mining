function [ nb ] = nobias( ker )
% nobias �˴���ʾ�йش˺�����ժҪ
% nobias returns true if SVM kernel has no implicit bias
%
%  Usage: nb = nobias(ker)
%
%  Parameters: ker - kernel type
%              
%   �˴���ʾ��ϸ˵��
    if (nargin ~= 1)
        help nobias
    else
        switch lower(ker)
            case {'linear', 'rbf'}
                nb = 1;
            otherwise
                nb = 0;
        end
    end
end

