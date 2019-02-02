function [data]=param_search_horizontal()
    % Transducer Geometry
    kerf = 0.4;
    r_width = [4 6 8];
    z_width = [4 6 8];
    
    %Array Geometry
    N_Elements_Z = [4 5 6];
    %Nx * Nz = [256, 512];
   
    Semi_Major_Axis = [180/2, 240/2, 300/2];
    % 1. circular 2. elliptical 
    Semi_Minor_Axis_Ratio = [1, 135/170];
    R_Focus_Ratio = [1 , 1e15];
    % Steering
    Slice_XYZ = {'xy','xz','yz'};
    X = 0 : 20 : 40;
    Y = 0; %0 : 20 : 40;
    Z = 0 : 20 : 40;
    
    for A_i = 1:length(Semi_Major_Axis)
        A = Semi_Major_Axis(A_i);
    for B_i = 1:length(Semi_Minor_Axis_Ratio)
        B = A*Semi_Minor_Axis_Ratio(B_i);
    for R_focus_i = 1:length(R_Focus_Ratio)
        R_focus = A*R_Focus_Ratio(R_focus_i);
    for r_width_i = 1:length(r_width)
        D = zeros(1,2);
        D(1) = r_width(r_i);
    for z_width_i = 1:length(z_width)
        D(2) = z_width(z_width_i);
    for nz_i = 1:length(N_Elements_Z)
        n_z = N_Elements_Z(nz_i);
    for slice_i = 1:length(Slice_XYZ)
        slice = Slice_XYZ(slice_i);
    for x_i = 1:length(X)
        x = X(x_i);
    for y_i = 1:length(Y)
        y = Y(y_i);
    for z_i = 1:length(Z)
        z = Z(z_i);
    
        
        
        
    [txfield, xdc_data]=horizontal_array_simulation(n_r, n_z,A,B,D,[x,y,z],...,
        'R_focus',R_focus,'Slice',slice,'visualize_output',false);
    
    
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    
end