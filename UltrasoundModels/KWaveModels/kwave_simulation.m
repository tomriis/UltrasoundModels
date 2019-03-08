
function [sensor_data,source,mask, ijk] = kwave_simulation(varargin)
    
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
    % Define excitation
    magnitude = 0.5; %[Pa]
    fo = 650e3;
    fs=20*fo;
    
    % create the computational grid
    kgrid = define_kgrid(3, fs);

    % Define the source
    a = p.Results.a; %mm
    b = p.Results.b;
    n_elements_r = p.Results.n_elements_r;  %number of physical elements in X.
    n_elements_y = p.Results.n_elements_y;  %number of physical elements in Y.
    kerf = p.Results.kerf;
    D = p.Results.D; %Diameter, width, and length of element (mm)
    R_focus = p.Results.R_focus;
    type = p.Results.type;
    focus = p.Results.focal_point/1000; %(m)
    
    [rect]= kwave_focused_array(n_elements_r,n_elements_y, kerf/1000,...,
        D/1000, R_focus/1000,a/1000,b/1000,type);
    
    % Adjust rect to grid
    mv = max(rect(end,:));
    shift_z = -(mv-kgrid.z_vec(end-2));
    rect = translate_rect([0,0,shift_z]', rect);
    focus(3) = focus(3)+shift_z;
    
    % Compute delays
    delays = compute_delays(rect, focus, c);
    
    % Define source
    [source.p_mask, ijk] = rect_to_mask(kgrid, rect);
    source.p = define_source_excitation(ijk,kgrid,delays, fo, magnitude,Dimensions);
      
    % Define a sensor mask 
    sensor.mask = define_sensor_mask(kgrid,focus,slice,Dimensions);
    
    c = 1490; % Speed of sound in water
    % Run the simulation
    if Dimensions == 2
        kgrid = define_kgrid(Dimensions, fs);
        % Define the medium properties   
        medium.sound_speed = c*ones(kgrid.Nx, kgrid.Nz); % [m/s]
        medium.density = 1040;                  % [kg/m^3]
 
        sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor,'DataCast', 'single');
    else
        medium.sound_speed = c*ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
        sensor_data= kspaceFirstOrder3D(kgrid, medium, source,sensor,'DataCast','single');
    end
    txfield = 0;
end
