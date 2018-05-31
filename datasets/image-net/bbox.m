function [ coord ] = bbox( wnid, id )
%ANNOTATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    folder = sprintf('./Annotation/%s', wnid);
    file = sprintf([folder, '/%s_%d.xml'], wnid, id);
    xDoc = xmlread(file);
    childNodes = xDoc.getChildNodes;
    annotation = childNodes.item(0);
    object = annotation.item(11);
    bnbbox = object.item(9);
    coord = zeros(1, 4);
    for i = [1 3 5 7]
       item  = bnbbox.item(i);
       text = item.item(0);
       str = text.getData();
       num = str2double(str);
       coord(1, (i+1)/2) = num;
    end
end