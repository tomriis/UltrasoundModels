n_elements_r = 42;
n_elements_y = 6;
a = 120;
b = 120;
D = [6,8];
R_focus = a;
slice = 'xy';
type = 'concave';
f_x = 25;

f_y = 0;
f_z = 0;
Dimensions = 3;
focus = [f_x,f_y,f_z];

[txfeilddb, xdc_data] = human_array_simulation(n_elements_r, n_elements_y,a,...,
D,focus,'R_focus',R_focus,...,
'Slice',slice, 'visualize_output',true);
