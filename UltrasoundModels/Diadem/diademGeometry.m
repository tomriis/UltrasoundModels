function [allrect,allcent] = diademGeometry(Nw, Nh, Rw, Rh, W, kerf, xArrayToSagitalPlane)
    [rectangles, cent, elementMapping] = condensedThroughTransmitArray(Nw, Nh, Rw, Rh, W, kerf, xArrayToSagitalPlane); 
    allrect = [];
    allcent = [];

    allrect = [allrect; rectangles'];
    allcent = [allcent; cent'];

    xcordsi = [2, 5, 8, 11, 17]; 
    zcordsi = [4, 7, 10, 13, 19]-2; %for rectangles

    rotw = makezrotform(pi);


    rectangles = apply_affine_to_rect(rotw, rectangles);
    %         rectangles(zcordsi, :) = - rectangles(zcordsi, :);
    rectangles(1, :) = size(allrect, 1) + 1 : size(allrect, 1) + size(rectangles, 2);
    cent(3, :) = -cent(3, :);
    allrect = [allrect; rectangles'];
    allcent = [allcent; cent'];
end