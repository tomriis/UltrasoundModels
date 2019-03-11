function kgrid = define_kgrid(rect,focus, kerf, fs,Dimensions, c, type)
    R = find_rect_max_xyz(rect);
    for i = 1:3
        if abs(focus(i))>R(i)
            R(i) = abs(focus(i));
        end
    end
        
    padding = 100;
    scaling = 2;
    dx = kerf/scaling;
    dy = dx;
    dz = dx;
    
    Nx = ceil(2*R(1)/dx)+padding;
    Ny = ceil(2*R(2)/dy)+padding;
    
    if strcmp(type, 'horizontal')
        Nz = ceil(2*R(3)/dz)+padding;
    else
        if focus(3) < 0
            R(3)= R(3)+abs(focus(3));
        end
        Nz = ceil(2*R(3)/dz)+padding;
    end
    if Dimensions == 2
        kgrid = makeGrid(Nx, dx, Nz,dz);
    else
        kgrid = makeGrid(Nx, dx, Ny, dy, Nz, dz);
    end
    
    tmax = (Nz+padding)*dz/c;
    kgrid.dt = 1/fs;
    kgrid.t_array = 0:kgrid.dt:tmax;
end