function [ discr, count ] = batch_dsift( folder, wnids )
%BATCH_DSIFT �˴���ʾ�йش˺�����ժҪ
% Batch Dense SIFT
%   �˴���ʾ��ϸ˵��
   
    discr = []; % Dense SIFT������
    count = []; % Dense SIFT����ͳ��
    for ci = 1 : size(wnids, 1)
        files = ls(fullfile(folder, wnids{ci}, '*.jpg'));
        for fi = 1 : size(files, 1)
            try
                file = fullfile(folder, wnids{ci}, files(fi,:));
                fprintf('image_dsift:%s\n', files(fi,:));
                I = imread(file);
                [~, d] = image_dsift(I);
                [~, n] = size(d);
                
%                 clf
%                 imshow(I);
%                 hold on;
%                 plot_sift( f, d );

                discr = cat(2, discr, d);
                count = cat(1, count, n);
            catch MException
                fprintf('MException in:%s\n', files(fi,:));
            end
        end
    end
end