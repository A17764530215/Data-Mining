function [ bbox ] = load_bbox( file, mode )
%LOAD_BBOX 此处显示有关此函数的摘要
%   此处显示详细说明

    switch mode
        case '101'
            bbox = load_101_bbox(file);
        case 'xml'
            bbox = load_xml_bbox(file);
        otherwise
            throw(MException('load_bbox', 'unknown mode'));
    end

    function bbox = load_101_bbox(file)
        load(file, 'box_coord', 'obj_contour');
        bbox = [box_coord(3), box_coord(1), box_coord(4)-box_coord(3), box_coord(2)-box_coord(1)];
    end

    function bbox = load_xml_bbox(file)
        xDoc = xmlread(file);
        childNodes = xDoc.getChildNodes;
        annotation = childNodes.item(0);
        object = annotation.item(11);
        bnbbox = object.item(9);
        bbox = zeros(1, 4);
        for i = [1 3 5 7]
           item  = bnbbox.item(i);
           text = item.item(0);
           str = text.getData();
           num = str2double(str);
           bbox(1, (i+1)/2) = num;
        end
    end
end