% function []=param_search_horizontal()
    % Transducer Geometry
    kerf = [2.0, 4.0, 6.0,];
    r_width = [6];
    z_width = [6];%[5, 6, 7];
    
    %Array Geometry
    N_Elements_Z = [6]; %[4 5 6];
    %Nx * Nz = [256, 512];
    total_elements = 256;
    Semi_Major_Axis = 118;
    % 1. circular 2. elliptical 
    Semi_Minor_Axis_Ratio = [90/118];
    R_Focus_Ratio = [1];%, 1e12];
    R_foci = 118;%[105,110,115,118,120,125,130,260,999];
    % Steering
    Slice_XYZ = {'xy','xz','yz'};
    X = [0, 15, 30, 40];
    Z = [0,15,30];
    Y = [-10,0,10];
    %% Define the excitation
    f0= 650000; fs = 20*f0;
    cycles = 5; amplitude = 300000000;
    excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));
    %%
    total = length(X)*length(Z)*length(Y)*length(Slice_XYZ)*length(R_Focus_Ratio)*...
        length(Semi_Minor_Axis_Ratio)*length(Semi_Major_Axis)*length(N_Elements_Z)*...
        length(r_width)*length(z_width)*length(kerf);
    
    data = struct();
  
    count = 1;
    for A_i = 1:length(Semi_Major_Axis)
        A = Semi_Major_Axis(A_i);
    for B_i = 1:length(Semi_Minor_Axis_Ratio)
        B = A*Semi_Minor_Axis_Ratio(B_i);
    for k_i = 1:length(kerf)
        K = kerf(k_i);
        R_focus = A;%R_foci(R_focus_i);
    for r_width_i = 1:length(r_width)
        D = zeros(1,2);
        D(1) = r_width(r_width_i);
    for z_width_i = 1:length(z_width)
        D(2) = z_width(z_width_i);
    for nz_i = 1:length(N_Elements_Z)
        n_z = N_Elements_Z(nz_i);
        n_r = 43;%floor(total_elements/n_z);
        p = ellipse_perimeter(A,B);
%         if n_r*(D(1)+kerf) > p
%             n_r = floor(p/(D(1)+kerf));
%         end
    for slice_i = 1:length(Slice_XYZ)
        slice = Slice_XYZ{slice_i};
    for x_i = 1:length(X)
        x = X(x_i);
    for y_i = 1:length(Y)
        y = Y(y_i);
    for z_i = 1:length(Z)
        z = Z(z_i);
        
    disp('-----------------------------------------')
    disp('-----------------------------------------')
    disp(strcat('      ',num2str(count),' of ', num2str(total)));
    disp('-----------------------------------------')
    disp('-----------------------------------------')
    count = count + 1;    

    [max_hp, sum_hilbert, xdc_data]=horizontal_array_simulation(n_r, n_z,A,B,D,[x,y,z],...,
            'R_focus',R_focus,'Slice',slice,'kerf',K,'excitation', excitation);
    
    data(count).xdrData = xdc_data;
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
    data(count).slice = slice;
    data(count).excitation = excitation;
        
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
    save('PowerScan.mat','data');

    try
        sendmail('tomriis11@gmail.com','Code Power Scan');
    catch
        disp('Email Failed');
    end
% end