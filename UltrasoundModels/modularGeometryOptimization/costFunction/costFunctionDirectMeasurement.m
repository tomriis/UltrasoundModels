function J = costFunctionDirectMeasurement(params)
    %costFunctionDirectMeasurement uses algorithms for measureing pressure
    %at focus, size of focus, and presense of grating lobs. With these
    %multiple objectives, must add weights for each sub-objective 
    % after some form of normalizing each.
    wMaxPressure = 2;
    wFWHM = 1;
    data = horizontalGeometryScan3D(params);
    cost = zeros([1,length(data)]);
    
    for i = 1:length(data)
        field = data(i).max_hp';
        x = data(i).x;
        y = data(i).y;
        fieldMax = -1*max(max(field));
        focus = data(i).focus;
        try
            FWHM = max(fullWidthHalfMax(field, x,y, focus, [1,2]));
        catch
            FWHM = 10;
        end
        FWHM = 100*FWHM; % convert to cm
        cost(i) = wMaxPressure*fieldMax + wFWHM*FWHM;
    end
    J = max(cost);
end
    
    