function [x,y,z] = get_slice_xyz(plane, focus,varargin)
    if ~isempty(varargin)
        npoints = varargin{1};
        stepSize = round(120/npoints,1);
    else
        stepSize = 0.4;
    end
    stepSize = 0.4;
    limit = 55;
    switch plane
        case 'xy'
            x = (-limit : stepSize : limit)*1e-3;
            y = (-limit : stepSize : limit)*1e-3;
            z = focus(3);
        case 'xz'
            x = (-limit : stepSize : limit)*1e-3;
            y = focus(2);
            z =(-limit : stepSize : limit)*1e-3;
        case 'yz'
            x = focus(1);
            y = (-limit : stepSize : limit)*1e-3;
            z = (-limit : stepSize : limit)*1e-3;
    end
end