function [ images, labels ] = load_mnist( file )
%LOAD_MNIST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    % ��ȡimagesͷ���ֶ�
    fp = fopen([file, '-images.idx3-ubyte'], 'rb');
    assert(fp ~= -1, ['Could not open ', file, '']);
    magic = fread(fp, 1, 'int32', 0, 'ieee-be');
    assert(magic == 2051, ['Bad magic number in ', file, '']);
    % ��ȡ���ݼ���Ϣ
    n_images = fread(fp, 1, 'int32', 0, 'ieee-be');
    n_row = fread(fp, 1, 'int32', 0, 'ieee-be');
    n_col = fread(fp, 1, 'int32', 0, 'ieee-be');
    % ��ȡ���ݼ�
    images = fread(fp, inf, 'unsigned char');
    images = reshape(images, n_col, n_row, n_images);
    images = permute(images, [2 1 3]);
    fclose(fp);
    % ��һ��
    images = reshape(images, size(images, 1)*size(images, 2), size(images, 3));
    images = double(images)/255;
    % ��ȡlabelsͷ���ֶ�
    fp = fopen([file, '-labels.idx1-ubyte'], 'rb');
    assert(fp ~= -1, ['Could not open ', file, '']);
    magic = fread(fp, 1, 'int32', 0, 'ieee-be');
    assert(magic == 2049, ['Bad magic number in ', file, '']);
    % ��ȡ��ǩ
    n_labels = fread(fp, 1, 'int32', 0, 'ieee-be');
    labels = fread(fp, inf, 'unsigned char');
    labels = reshape(labels, n_labels, 1);
    assert(size(labels, 1) == n_labels, 'Mismatch in label count');
    fclose(fp);
end

