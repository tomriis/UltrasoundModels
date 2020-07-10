function [x,y,z] = get_plane_xyz(plane, focus)
    stepSize = 0.25;
    limit = 35;
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