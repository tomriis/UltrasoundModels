function [x,y,z] = get_slice_xyz(plane, focus,varargin)
    if ~isempty(varargin)
        npoints = varargin{1};
        stepSize = round(120/npoints,1);
    else
        stepSize = 0.4;
    end
    
    switch plane
        case 'xy'
            x = (-60 : stepSize : 60)*1e-3;
            y = (-60 : stepSize : 60)*1e-3;
            z = focus(3);
        case 'xz'
            x = (-60 : stepSize : 60)*1e-3;
            y = 0;
            z =focus(3)+(-60 : stepSize : 60)*1e-3;
        case 'yz'
            x = focus(1);
            y = (-60 : stepSize : 60)*1e-3;
            z = focus(3)+(-60 : stepSize : 60)*1e-3;
    end
end