function [ discr, count, class ] = batch_dsift( folder, wnids )
%BATCH_DSIFT �˴���ʾ�йش˺�����ժҪ
% Batch Dense SIFT
%   �˴���ʾ��ϸ˵��
   
    discr = [];
    count = [];
    class = [];
    nwnid = size(wnids, 1);
    for ci = 1 : nwnid
        files = ls(fullfile(folder, wnids{ci}, '*.jpg'));
        nfile = size(files, 1);
        class = cat(1, class, ci*ones(nfile, 1));
        for fi = 1 : nfile
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