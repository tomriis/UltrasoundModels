n_elements_r = 5;
n_elements_y = 1;
a = 120/1000;
b = 120/1000;
D = [6,8]/1000;
R_focus = a;
slice = 'xy';
type = 'concave';
f_x = 20;

f_y = 0;
f_z = 0;
Dimensions = 3;
focus = [f_x,f_y,f_z]/1000;

[sensor_data, kgrid, medium, source, sensor] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D,focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',2,'type',type);
