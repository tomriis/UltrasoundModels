n_elements_r = 51;
n_elements_y = 1;
a = 120;
b = 120;
D = [6,8];
R_focus = a;
slice = 'xy';
type = 'concave';
f_x = 0;
f_y = 0;
f_z = 0;


[sensor_data, kgrid, medium, source, sensor,ijk] = kwave_simulation(n_r, n_y,A,B,D,[f_x,f_y,f_z],'R_focus',R_focus,...,
    'Slice',slice,'Dim',2,'type',type);
