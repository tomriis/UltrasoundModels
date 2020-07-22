function [data] = horizontalGeometryScan3D(x)
    
    focus = [25,0,0]/1000;
    f0= 650000; fs = 20*f0;
    cycles = 25; amplitude = 300000000;
    excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));
    Plane_XYZ = {'xy','xz','yz'};
    count = 1;
    A = 0.120;
    B = 0.1;
    for i = 1:length(Plane_XYZ)
        [max_hp, sum_hilbert, xdc_data]=horizontal_array_simulation(42, 6, A, B,[6,6]/1000, focus,...,
                'kerf',x(1),'R_focus',(A-B)*x(2)+B,'Plane',Plane_XYZ{i},'excitation', excitation);
            %(x(1)-x(2))*x(4)+x(2)
        data(count).xdrData = xdc_data;
        data(count).max_hp = max_hp;
        data(count).sum_hilbert = sum_hilbert;
        data(count).focus = focus;
        data(count).plane = Plane_XYZ{i};
        data(count).excitation = excitation;
        [x,y,z] = get_plane_xyz(Plane_XYZ{i}, focus);
        if strcmp(data(count).plane, 'yz')
            x = y;
            y = z;
        elseif strcmp(data(count).plane,'xz')
            y = z;
        end
        data(count).x = x;
        data(count).y = y;
        
        count = count + 1;
    end
end
