function [ im ] = FRAME( h )
%FRAME �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    drawnow();
    frame = getframe(h);
    im = frame2im(frame);
end

