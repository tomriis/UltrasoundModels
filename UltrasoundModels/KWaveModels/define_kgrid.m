function kgrid = define_kgrid(rect,focus, kerf, fs,Dimensions, c, type,delays)
    R = find_rect_max_xyz(rect);
    for i = 1:3
        if abs(focus(i))>R(i)
            R(i) = abs(focus(i));
        end
    end
        
    padding = 100;
    scaling = 2;
    dx = 0.25e-3;%kerf/scaling;
    dy = dx;
    dz = dx;
    
    Nx = 720;%ceil(2*R(1)/dx)+padding;
    Ny = 270;%ceil(2*R(2)/dy)+padding;
    Nz = 864;%ceil(2*R(3)/dz)+padding;
    disp(Nx)
    disp(Nz)
    
    if Dimensions == 2
        kgrid = makeGrid(Nx, dx, Nz,dz);
    else
        kgrid = makeGrid(Nx, dx, Ny, dy, Nz, dz);
    end
    
    tmax = max(delays)+(2/3)*Nz*dz/c;
    kgrid.dt = 1/fs;
    kgrid.t_array = 0:kgrid.dt:tmax;
end