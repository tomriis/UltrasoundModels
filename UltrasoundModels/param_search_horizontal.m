function [data]=param_search_horizontal()
    % Transducer Geometry
    Nz = [4 5 6];
    z_width = [4 6 8];
    %Nx * Nz = [256, 512];
    r_width = [4 6 8]
    %Array Geometry
    %1. circular
    R = [180/2, 240/2, 300/2];
    %2. elliptical 
    R1 = [180/2, 240/2, 300/2]; R2 = 135/170 * R1

    %steering
    x = [0 : 20 : 40];
    y = [0 : 20 : 40];
    z = [0 : 10 : 20];
    [txfield, xdc_data]=horizontal_array_simulation(64,4,135,175);
end