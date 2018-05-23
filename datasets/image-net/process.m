function [ strs, bbox ] = process( wnid )
%PROCESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    options = weboptions('Timeout', 300);
    api = 'http://www.image-net.org/api/';
%     url = [api, 'text/imagenet.sbow.obtain_synset_list'];
%     url = [api, 'download/imagenet.sbow.synset?wnid=%d'];
    % ��ȡͼƬ����
    url = [api, 'text/imagenet.synset.geturls?wnid=%s'];
    strs = webread(sprintf(url, wnid), options);
    save([wnid, '-urls'], 'strs');
    % ��ȡ����
    url = [api, 'download/imagenet.bbox.synset?wnid=%s'];
    bbox = webread(sprintf(url, wnid), options);
    save([wnid, '-bbox'], 'bbox');
end