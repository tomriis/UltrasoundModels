function [txfield,source,mask] = kwave_simulation(varargin)
    
    p = inputParser;
    addRequired(p,'n_elements_r', @(x) isnumeric(x));
    addRequired(p,'n_elements_y', @(x) isnumeric(x));
    addRequired(p,'a', @(x) isnumeric(x));
    addRequired(p,'b', @(x) isnumeric(x));
    addRequired(p,'D');
    addRequired(p, 'focal_point');
    addOptional(p, 'Dim',2);
    addOptional(p,'type','horizontal');
    addOptional(p, 'kerf',0.4);
    addOptional(p, 'R_focus', 1e4, @(x) isnumeric(x));
    addOptional(p,'Slice','xy');
    parse(p, varargin{:})
    
    Dimensions = p.Results.Dim;
    % create the computational grid
    Nx = 2048;
    Ny = 64;
    Nz = 128;
    dx = 2e-4;
    dy = 1e-3;
    dz = 10e-4;
    kgrid = makeGrid(Nx, dx, Ny, dy, Nz, dz);
    % Define the source
    a = p.Results.a; %mm
    b = p.Results.b;
    n_elements_r = p.Results.n_elements_r;  %number of physical elements in X.
    n_elements_y = p.Results.n_elements_y;  %number of physical elements in Y.
    kerf = p.Results.kerf;
    D = p.Results.D; %Diameter, width, and length of element (mm)
    R_focus = p.Results.R_focus;
    type = p.Results.type;
    
    mask = kwave_focused_array(kgrid, n_elements_r, n_elements_y, kerf/1000, D/1000, R_focus/1000,a/1000,b/1000,type);
 
    if Dimensions == 2
        source.p_mask = reshape(any(mask,2),[kgrid.Nx,kgrid.Nz]);
    end
        
    % define the medium properties
    medium.sound_speed = 1500*ones(Nx, Ny, Nz); % [m/s]
    medium.density = 1040;                  % [kg/m^3]
    % define a sensor mask 

    
    % run the simulation
    
    %sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor,'DataCast', 'single');
    txfield = 0;
end
