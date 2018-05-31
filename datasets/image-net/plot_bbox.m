function [  ] = plot_bbox( wnid, id )
%PLOT_BBOX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    % ����ͼƬ
    folder = sprintf('./Images/%s/', wnid);
    file = sprintf([folder, wnid, '_%04d.jpg'], id);
    try
        im = imread(file);
        imshow(im);
    catch MException
        fprintf('No such file:%s\n', file);
    end
    % ��������
    box = bbox(wnid, id);
    rectangle('position', [box(1), box(2), box(3)-box(1), box(4)-box(2)]);    
end