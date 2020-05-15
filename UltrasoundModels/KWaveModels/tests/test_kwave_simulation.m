n_elements_r = 43;
n_elements_y = 6;
a = 110;
b = 90;
D = [6, 6];
R_focus = a;
slice = 'xy';
type = 'horizontal';
f_x = 0;

f_y = 0;
f_z = 0;
Dimensions = 3;
focus = [f_x,f_y,f_z];

[sensor_data] = kwave_human_array_simulation(n_elements_r,...,
    n_elements_y, a, b, D,focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',Dimensions,'type',type);

