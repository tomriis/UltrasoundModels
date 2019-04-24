function kgrid = define_kgrid(rect,focus, fs,Dimensions, c,delays)
    R = find_rect_max_xyz(rect);
    for i = 1:3
        if abs(focus(i))>R(i)
            R(i) = abs(focus(i));
        end
    end
        
    padding = 100;
    scaling = 2;
    dx = 0.162e-3;%kerf/scaling;
    dy = dx;
    dz = dx;
    
    Nx = ceil(2*R(1)/dx)+padding;
    Ny = ceil(2*R(2)/dy)+padding;
    Nz = ceil(3/2*R(3)/dz)+padding;
    disp(Nx)
    disp(Nz)
    
    if Dimensions == 2
        kgrid = kWaveGrid(Nx, dx, Nz,dz);
    else
        kgrid = kWaveGrid(Nx, dx, Ny, dy, Nz, dz);
    end
    
    tmax = Nz*dz/c; 
    kgrid.dt = 1/fs;
    kgrid.t_array = 0:kgrid.dt:tmax;
end