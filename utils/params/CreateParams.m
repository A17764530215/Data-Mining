function [ Params ] = CreateParams(root)
%CREATEPARAMS �˴���ʾ�йش����ժҪ
% �������������
%   �˴���ʾ��ϸ˵��
    
    nParams = GetParamsCount(root);
    Params = repmat(GetParams(root, 1), nParams, 1);
    for index = 2 : nParams
        Params(index) = GetParams(root, index);
    end  
end