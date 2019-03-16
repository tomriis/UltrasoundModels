function [mask] = define_sensor_mask(kgrid, focus, plane, Dimension)
    limit = 55; %[mm]
    if Dimension == 2
        mask=zeros(kgrid.Nx,kgrid.Nz);
    else 
        mask = zeros(kgrid.Nx, kgrid.Ny, kgrid.Nz);
    end

    switch plane
        case 'xy'
            x = (-limit : limit)*1e-3;
            y = (-limit :limit)*1e-3;
            z = focus(3);
        case 'xz'
            x = (-limit : limit)*1e-3;
            y = focus(2);
            z =(-limit : limit)*1e-3;
        case 'yz'
            x = focus(1);
            y = (-limit : limit)*1e-3;
            z = (-limit : limit)*1e-3;
    end
    
    [ijk] = coordinates_to_index(kgrid, [x(1),y(1),z(1)]);
    [ijkend] = coordinates_to_index(kgrid, [x(end),y(end),z(end)]);
    x=ijk(1):ijkend(1); y = ijk(2):ijkend(2); z = ijk(3):ijkend(3);
    for i = x
        for j = y
            for k = z
               if Dimension == 2
                   mask(i,k) = 1;
               else
                   mask(i,j,k) = 1;
               end
            end
        end
    end
end