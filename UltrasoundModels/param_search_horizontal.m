% function []=param_search_horizontal()
    % Transducer Geometry
    kerf = [2.45]/1000;
    r_width = [8]/1000;
    z_width = [8]/1000;
    
    N_Elements_Z = [8]; %[4 5 6];
    
    Semi_Major_Axis = [110]/1000;
    Semi_Minor_Axis_Ratio = [90/110];
    R_Focus_Ratio = [1.5];
    xdr_angle = [0.5];
    % Steering
    Plane_XYZ = {'xz'};
    X = [0,15,30,40]/1000;
    Z = [0]/1000;
    Y = [0]/1000;
    %% Define the excitation
    f0= 650000; fs = 20*f0;
    cycles = 50; amplitude = 300000000;
    excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));
    %%
    total = length(X)*length(Z)*length(Y)*length(Plane_XYZ)*length(R_Focus_Ratio)*...
        length(Semi_Minor_Axis_Ratio)*length(Semi_Major_Axis)*length(N_Elements_Z)*...
        length(r_width)*length(z_width)*length(kerf)*length(xdr_angle);
    
    data = struct();
    count = 1;
    for A_i = 1:length(Semi_Major_Axis)
        A = Semi_Major_Axis(A_i);
    for B_i = 1:length(Semi_Minor_Axis_Ratio)
        B = A*Semi_Minor_Axis_Ratio(B_i);
    for k_i = 1:length(kerf)
        K = kerf(k_i);
    for r_width_i = 1:length(r_width)
        D = zeros(1,2);
        D(1) = r_width(r_width_i);
    for z_width_i = 1:length(z_width)
        D(2) = z_width(z_width_i);
    for nz_i = 1:length(N_Elements_Z)
        n_z = N_Elements_Z(nz_i);
        n_r = 32;%floor(total_elements/n_z);
    for slice_i = 1:length(Plane_XYZ)
        slice = Plane_XYZ{slice_i};
    for x_i = 1:length(X)
        x = X(x_i);
    for y_i = 1:length(Y)
        y = Y(y_i);
    for z_i = 1:length(Z)
        z = Z(z_i);
    for R_focus_i = 1:length(R_Focus_Ratio)
        R_focus = R_Focus_Ratio(R_focus_i)*A;    
    for xdr_angle_i = 1:length(xdr_angle)
        columnAngle = xdr_angle(xdr_angle_i);
        
    disp('-----------------------------------------')
    disp('-----------------------------------------')
    disp(strcat('      ',num2str(count),' of ', num2str(total)));
    disp('-----------------------------------------')
    disp('-----------------------------------------')
      

    [max_hp, sum_hilbert, xdc_data]=horizontal_array_simulation(n_r, n_z,A,B,D,[x,y,z],...,
            'kerf',K,'R_focus',R_focus,'Plane',slice,'excitation', excitation,...,
            'columnAngle',columnAngle);
    
    data(count).xdcData = xdc_data;
    data(count).max_hp = max_hp;
    data(count).sum_hilbert = sum_hilbert;
    data(count).NR = n_r;
    data(count).NZ = n_z;
    data(count).A = A;
    data(count).B = B;
    data(count).D = D;
    data(count).focus = [x,y,z];
    data(count).R_focus = R_focus;
    data(count).kerf = K;
    data(count).plane = slice;
    data(count).excitation = excitation;
    data(count).columnAngle = columnAngle;
    count = count + 1;  
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
    end
    save('D:\modularGeometryOptimization\testFinalTxRxGeometry8x8.mat','data');
