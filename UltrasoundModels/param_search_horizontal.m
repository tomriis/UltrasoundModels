function []=param_search_horizontal()
    % Transducer Geometry
    kerf = 0.4;
    r_width = [5, 6];
    z_width = [5, 6];
    
    %Array Geometry
    N_Elements_Z = [6];%[4 5 6];
    %Nx * Nz = [256, 512];
    total_elements = 256;
    Semi_Major_Axis = 118;
    % 1. circular 2. elliptical 
    Semi_Minor_Axis_Ratio = [1 90/118];
    R_Focus_Ratio = [1];%, 1e12];
    % Steering
    Slice_XYZ = {'xy','xz','yz'};
    X = [0, 20, 30, 40];
    Y = [0,15,30];
    Z = 0 : 20 : 40;
    
    total = length(X)*length(Z)*length(Y)*length(Slice_XYZ)*length(R_Focus_Ratio)*...
        length(Semi_Minor_Axis_Ratio)*length(Semi_Major_Axis)*length(N_Elements_Z)*...
        length(r_width)*length(z_width);
    
    data = struct();

    data1 = struct();
    data2 = struct();
    count = 1;
    for A_i = 1:length(Semi_Major_Axis)
        A = Semi_Major_Axis(A_i);
    for B_i = 1:length(Semi_Minor_Axis_Ratio)
        B = A*Semi_Minor_Axis_Ratio(B_i);
    for R_focus_i = 1:length(R_Focus_Ratio)
        R_focus = A*R_Focus_Ratio(R_focus_i);
    for r_width_i = 1:length(r_width)
        D = zeros(1,2);
        D(1) = r_width(r_width_i);
    for z_width_i = 1:length(z_width)
        D(2) = z_width(z_width_i);
    for nz_i = 1:length(N_Elements_Z)
        n_z = N_Elements_Z(nz_i);
        n_r = 42;%floor(total_elements/n_z);
        p = ellipse_perimeter(A,B);
        if n_r*(D(1)+kerf) > p
            n_r = floor(p/(D(1)+kerf));
        end
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
    s = struct();
    
    if R_focus < 100000
        ElGeo = 2;
    else 
        ElGeo = 1;
    end
    s.ElGeo = ElGeo; s.NR = n_r; s.NY =n_z; s.A = A; s.B = B; s.D = D; s.F=[x,y,z];
    s.Slice = slice; s.Ro = R_focus; s.T = total_elements; s.EX = 'g';
    
    fname = fieldname_from_params(s);

    [max_hp, sum_hilbert, xdc_data]=horizontal_array_simulation(n_r, n_z,A,B,D,[x,y,z],...,
            'R_focus',R_focus,'Slice',slice,'visualize_output',false);
    
        data.(fname) = max_hp;
        k = strfind(fname,'SUM');
        fname(k+3:end) = 'sh';
        data1.(fname) = sum_hilbert;
%         fname(k+3:end) = 'mh';
%         data2.(fname) = max_hilbert;      
        k = strfind(fname,'Slice_');
        gname = fname(1:k-1);
        data.(strcat('G_',gname)) = xdc_data;

    
    
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
    save('g_42_geo_max_hp.mat','-struct','data');
    save('g_42_geo_sum_hilbert.mat','-struct','data1');
    try
        sendmail('tomriis11@gmail.com','Code DC 33', ...
        ['focus_outward_.mat' 10 'Finish Filters']);
    catch
        disp('Email Failed');
    end
end