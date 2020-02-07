f0= 650000; fs = 20*f0;
cycles = 10; amplitude = 3.1245e8; %9.9953e7;
excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));


n_r = 22;
n_z =  12;
A = 115;
B = 85;
D = [6,6];
focus = [0,0,0];
R_focus = A;
slice = {'xy', 'xz', 'yz'};
data = struct();
K = 2.0;

for i = 1
    [max_hp, sum_hilbert, xdc_data]=horizontal_array_simulation(n_r, n_z,A,B,D,focus,...,
                'R_focus',R_focus,'Slice',slice{i},'kerf',K,'excitation', excitation);
            
    data(i).max_hp = max_hp;
    data(i).sum_hilbert = sum_hilbert;
    data(i).xdc_data = xdc_data;
end
[x,y,z] = get_slice_xyz(slice{i}, focus);
plotFieldII2DFigure(max_hp, focus, x, y);

show_transducer('data',xdc_data);