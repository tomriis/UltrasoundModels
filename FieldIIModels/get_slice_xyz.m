function [x,y,z] = get_slice_xyz(plane, focus)
    switch plane
        case 'xy'
            x = (-60 : 0.4 : 60)*1e-3;
            y = (-60 : 0.4 : 60)*1e-3;
            z = focus(3);
        case 'xz'
            x = (-60 : 0.4 : 60)*1e-3;
            y = 0;
            z =focus(3)+(-60 : 0.4 : 60)*1e-3;
        case 'yz'
            x = -focus(1);
            y = (-60 : 0.4 : 60)*1e-3;
            z = focus(3)+(-60 : 0.4 : 60)*1e-3;
    end
end