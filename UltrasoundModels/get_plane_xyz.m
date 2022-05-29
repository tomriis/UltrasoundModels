function [x,y,z] = get_plane_xyz(plane, focus)
    stepSize = 0.25;
    limit = 55;
    switch plane
        case 'xy'
            x = (-15 : stepSize : 15)*1e-3;
            y = (-5 : stepSize : 5)*1e-3;
            z = focus(3);
        case 'xz'
            x = (-15 : stepSize : 15)*1e-3;
            y = focus(2);
            z =(-5 : stepSize : 5)*1e-3;
        case 'yz'
            x = (-30 : stepSize : 30)*1e-3; %focus(1);
            y = (-30 : stepSize : 30)*1e-3;
            z = 0;
    end
end