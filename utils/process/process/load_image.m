function [ image ] = load_image(file, annotaion, mode, resize, show)
%LOAD_IMAGE 此处显示有关此函数的摘要
%   此处显示详细说明

    image = imread(file);
    
    if nargin > 2
        bbox = load_bbox(annotaion, mode);
        image = imcrop(image, bbox);
    end
    
    if nargin > 3 
        if resize
            image = imresize(image, [240, 320]);
        end
    end
    
    if nargin > 4
        if show
            imshow(image);
        end
    end
    
    if size(image, 3) >= 3
        image = rgb2gray(image);
    end
end