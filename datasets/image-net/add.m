function [ image_net ] = add( image_net, wnid, disc )
%ADD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    if isempty(find(strcmp(image_net(:,1), wnid), 1))
        [m, ~] = size(image_net);
        image_net(m + 1, :) = { wnid, disc };
    end
end