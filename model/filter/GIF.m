function [  ] = GIF( im, file )
%GIT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [nImages, ~] = size(im);
    for idx = 1 : nImages
        [A,map] = rgb2ind(im{idx},256);
        if idx < 3
            imwrite(A,map,file,'gif','LoopCount',Inf,'DelayTime',1);
        else
            imwrite(A,map,file,'gif','WriteMode','append','DelayTime',0.3);
        end
    end
end

