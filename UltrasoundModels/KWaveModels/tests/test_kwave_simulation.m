n_elements_r = 51;
n_elements_y = 1;
a = 120;
b = 120;
D = [6,8];
R_focus = a;
slice = 'xz';
type = 'concave';
f_x = 20;

f_y = 0;
f_z = 0;
Dimensions = 2;

[sensor_data, kgrid, medium, source, sensor] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D,[f_x,f_y,f_z],'R_focus',R_focus,...,
    'Slice',slice,'Dim',2,'type',type);
