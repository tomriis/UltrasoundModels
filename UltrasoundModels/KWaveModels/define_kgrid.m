function kgrid = define_kgrid(fs,Dimensions)
    Nx = 2048-650;
    Ny = 64;
    Nz = 128;
    dx = 2e-4;
    dy = 1e-3;
    dz = 10e-4;
    if Dimensions == 2
        kgrid = makeGrid(Nx, dx, Nz,dz);
    else
        kgrid = makeGrid(Nx, dx, Ny, dy, Nz, dz);
    end

    kgrid.dt = 1/fs;
    kgrid.t_array = 0:kgrid.dt:1e-6;
end