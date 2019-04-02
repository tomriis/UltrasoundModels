n_elements_r = 42;
n_elements_y = 1;
a = 90;
b = 75;
D = [4, 6];
R_focus = a;
slice = 'xy';
type = 'horizontal';
f_x = 25;

f_y = 0;
f_z = 0;
Dimensions = 2;
focus = [f_x,f_y,f_z];

[sensor_data] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D,focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',Dimensions,'type',type);

