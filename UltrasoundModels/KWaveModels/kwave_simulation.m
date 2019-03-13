
function [sensor_data,kgrid, medium, source, sensor] = kwave_simulation(varargin)
   %[sensor_data,kgrid, medium, source, sensor,ijk] = kwave_simulation(varargin) 
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

    % Define the source
    a = p.Results.a/1000; %m
    b = p.Results.b/1000;
    n_elements_r = p.Results.n_elements_r;  %number of physical elements in X.
    n_elements_y = p.Results.n_elements_y;  %number of physical elements in Y.
    kerf = p.Results.kerf/1000;
    D = p.Results.D/1000; %Diameter, width, and length of element (m)
    R_focus = p.Results.R_focus/1000;
    type = p.Results.type;
    focus = p.Results.focal_point/1000; %(m)
    slice = p.Results.Slice;
    
    [rect]= kwave_focused_array(n_elements_r,n_elements_y, kerf,...,
        D, R_focus, a, b,type);
    
    c = 1540; % Speed of sound in water
    % Compute delays
    delays = compute_delays(rect, focus, c);
    
    % create the computational grid
    kgrid = define_kgrid(rect,focus, kerf, fs,3, c, type);
    
    % Define source
    [source.p_mask, ijk, sensor_focus] = rect_to_mask(kgrid, rect, Dimensions, type, focus,1);
    disp("Running define_source_excitation");
    tic
    source.p = define_source_excitation(ijk, kgrid, delays, fo, magnitude,Dimensions);
    elapsedTime = toc;
    disp(strcat("define_source_excitation took ", num2str(elapsedTime)," seconds"));
    % Define a sensor mask 
    sensor.mask = define_sensor_mask(kgrid,sensor_focus,slice,Dimensions);
    
    disp("-------------------------------------")
    disp("  Model Defined, Running Simulation  ")
    disp("-------------------------------------")
   
    % Run the simulation
    if Dimensions == 2
        kgrid = define_kgrid(rect,focus, kerf, fs,2, c,type);
        % Define the medium properties   
        medium.sound_speed = c*ones(kgrid.Nx, kgrid.Ny); % [m/s]
        medium.density = 1040;                  % [kg/m^3]
 
        sensor_data = kspaceFirstOrder2D(kgrid, medium, source,...,
            sensor,'DataCast', 'gpuArray-single');
    else
        medium.sound_speed = c*ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
        sensor_data= kspaceFirstOrder3D(kgrid, medium, source,sensor,'DataCast','single');
        %kspaceFirstOrder3D-CUDA
    end
end

