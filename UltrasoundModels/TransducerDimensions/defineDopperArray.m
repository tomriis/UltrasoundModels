function array = defineDopperArray()
    D = [6 6]/1000;
    f = 650000;
    c = 1500;
    Nw = 14;
    Nh = 9;
    Rw = 165/1000;
    Rh = 165/1000;
    xArrayToSagitalPlane = (171/2)/1000; 
    kerf = 0.3/1000;
    field_init(-1);
    
     allrect = [];
    allcent = [];
    focus = [0,0,0];
      [rectangles, cent, elementMapping] = condensedThroughTransmitArray(Nw, Nh, Rw, Rh, D, kerf, xArrayToSagitalPlane); 
%     [rectangles, cent] = concave_focused_array_rectonly(Nh, Nw, Rh, kerf, D,Rw);
    % Flip and define second array
        xcordsi = [2, 5, 8, 11, 17]; 
        ycordsi = [3,6,9,12,18];
        zcordsi = [4,7,10,13,19];
        % Flip 1st array
            rectangles(zcordsi,:) = - rectangles(zcordsi,:);
    cent(3, :) = -cent(3, :);

    
%     zcordsi = [4, 7, 10, 13, 19]; %for rectangles
%     translx = 0; %xArrayToSagitalPlane-; %optional translation in z
%     rectangles(xcordsi, :) = rectangles(xcordsi, :) + translx;
%     cent(1, :) = cent(1, :) + translx;
    %
    allrect = [allrect; rectangles'];
    allcent = [allcent; cent'];
    %
    %2nd, opposing transducer
    % Flip X
    rectangles(xcordsi, :) = - rectangles(xcordsi, :);
    rectangles(1, :) = size(allrect, 1) + 1 : size(allrect, 1) + size(rectangles, 2);
    cent(1, :) = -cent(1, :);
                % Flip Y
    rectangles(ycordsi,:) = - rectangles(ycordsi,:);
    cent(2, :) = -cent(2, :);
    allrect = [allrect; rectangles'];
    allcent = [allcent; cent'];
    
%     size(allrect)
%     inds1 = randi(126,[1,63]);
%     inds2 = randi(126,[1,63])+126;
%     allrect([inds1,inds2],:)=[];
%     allcent([inds1,inds2],:)=[];
%     allrect(:,1) = 1:length(allrect);
    Tx = xdc_rectangles(allrect, allcent, focus);
    rect = xdc_pointer_to_rect(Tx);
    array.rect = rect;
    figure; show_transducer('data',array.rect);

    save('C:\Users\Verasonics\Documents\MATLAB\UltrasoundArrays\Arrays\diadem.mat','D','Nw','Nh','kerf','Rw','Rh','array','elementMapping');
end