function [ feats ] = load_task(image_path, bbox_path, limit)
%LOAD_TASK 此处显示有关此函数的摘要
% 加载任务
%   此处显示详细说明

    image_files = string(ls([image_path '*.jpg']));
    bbox_files  = string(ls([bbox_path '*.mat']));

    m = size(image_files, 1);
    n = size(bbox_files,1);

    num = min([m, n, limit]);
    feats = cell(num, 1); % Dense SIFT描述符
    for i = 1 : num
        image_ = [image_path, char(image_files(i))];
        bbox_ = [bbox_path, char(bbox_files(i))];
        image = load_image(image_, bbox_, '101', true, true);
        [~, d] = extractor(image, 'Dense SIFT');
        feats{i, 1} = d;
    end
end