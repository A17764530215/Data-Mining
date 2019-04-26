function [ f, d, hog ] = extractor( I, mode )
                
    switch mode
        case 'HOG'
            cellSize = 8;
            hog = vl_hog(I, cellSize, 'verbose');
        case 'SIFT'
            I = single(I);
            [f, d] = vl_sift(I, 'PeakThresh', 5, 'EdgeThresh', 5);
        case 'Dense SIFT'
            I = single(I) ;
            [f, d] = vl_dsift(I, 'Step', 16, 'Size', 8);
        otherwise
            throw(MException('extractor', ['unknown mode:', mode]));
    end
end