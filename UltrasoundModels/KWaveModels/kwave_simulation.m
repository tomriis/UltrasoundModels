function [sensor_data, source,kgrid] = kwave_simulation(rect, Dimensions, focus, plane)
    c = 1540; % Speed of sound in water
    magnitude = 0.5; %[Pa]
    fo = 650e3;
    fs=20*fo;
    type = '';
    % Compute delays
    delays = compute_delays(rect, focus, c);
    delays = delays-min(delays);
    % create the computational grid
    kgrid = define_kgrid(rect,focus, fs,3, c,delays);
    
    % Define source
    [source.p_mask, ijk, sensor_focus] = rect_to_mask(kgrid, rect, Dimensions, type, focus,1);
    disp("Running define_source_excitation");
    tic
    source.p = define_source_excitation(ijk, kgrid, delays, fo, magnitude,Dimensions);
    elapsedTime = toc;
    disp(strcat("define_source_excitation took ", num2str(elapsedTime)," seconds"));
    % Define a sensor mask 
    [sensor.mask, sensor_size] = define_sensor_mask(kgrid,sensor_focus,plane,Dimensions);
    
    disp("-------------------------------------")
    disp("  Model Defined, Running Simulation  ")
    disp("-------------------------------------")
   
    % Run the simulation
    if Dimensions == 2
        kgrid = define_kgrid(rect,focus, fs,2, c,delays);
        % Define the medium properties   
        medium.sound_speed = c;%*ones(kgrid.Nx, kgrid.Ny); % [m/s]
        medium.density = 1040;                  % [kg/m^3]
 
        sensor_data = kspaceFirstOrder2D(kgrid, medium, source,...,
            sensor,'DataCast', 'single');
    else
        medium.sound_speed = c;%*ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
        medium.density = 1040;
        %sensor_data= kspaceFirstOrder3D(kgrid, medium, source,sensor,'DataCast','gpuArray-single');
        sensor_data = kspaceFirstOrder3DC(kgrid,medium,source,sensor);
    end
    sensor_data = reshape(sensor_data, [sensor_size(1),sensor_size(2),...,
        length(kgrid.t_array)]);
end