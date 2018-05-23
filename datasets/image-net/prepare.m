function [  ] = prepare( wnid, strs, start, total )
%PREPARE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    folder = sprintf('./Images/%s/', wnid);
    if exist(folder, 'dir') == 0
        mkdir(folder);
    end
    options = weboptions('Timeout', 300);
    urls = strsplit(strtrim(strs), '\n')';
    [m, ~] = size(urls);
    count = min([m, total]);
    for i = start : count
        url = urls{i, 1};
        path = sprintf([folder, wnid, '_%04d.jpg'], i);
        if exist(path, 'file') == 0
            try
                pic = webread(url, options);
                imwrite(pic, path);
                fprintf('Success:%s', url);
            catch MException
                fprintf('Failed:%s', url);
            end
        else
            fprintf('Skip:%s', url);
        end
    end
end