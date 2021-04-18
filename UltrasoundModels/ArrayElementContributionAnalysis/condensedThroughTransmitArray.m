function rect = condensedThroughTransmitArray(Nh, Nw, Rh, Rw, D, kerf, xArrayToSagitalPlane)
    field_init(-1)
    angle_h = arrayColumnAngleZ(Rh, kerf,D,Nh,Nh/2);
    angle_w = arrayColumnAngleZ(Rw, kerf,D,Nw,Nw/2);
    rectangles=[];
    focused_rectangles = [];
    X = [2,5,8,11,17];
    count = 1;
    for i = 1:length(angle_h)
        for k = 1:length(angle_w)
            x = [0, 0]; y = [-D(2)/2 D(2)/2]; z = [-D(1)/2 D(1)/2];
            rect = [count x(1)  y(1)  z(1)  x(2)  y(1)  z(2)  x(2)  y(2)  z(2)  x(1)  y(2)  z(1)  1  D(1)  D(2)  0  0  0];
            rect = rect';
            roth = makezrotform(angle_h(i));
            rotw = makeyrotform(angle_w(k));
            rect(X,:)=rect(X,:)+Rh;
            rect = apply_affine_to_rect(roth, rect);
            rect(X,:)=rect(X,:)-Rh;

            rect(X,:)=rect(X,:)+Rw;
            rect = apply_affine_to_rect(rotw, rect);
            rect(X,:)=rect(X,:)-Rw;
            % Position X distance from brain sagital plane
            rect(X,:)=rect(X,:)+xArrayToSagitalPlane;
%           Append to transducer geometry
            focused_rectangles = horzcat(focused_rectangles, rect);
            count = count + 1;
        end
    end
    cent = focused_rectangles(end-2:end,:);
    Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
    rect = xdc_pointer_to_rect(Th);
end