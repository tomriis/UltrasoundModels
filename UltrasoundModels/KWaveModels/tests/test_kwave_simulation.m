n_r = 51;
n_y = 1;
A = 120;
B = 120;
D = [6,8];
R_focus = A;
slice = 'xy';
type = 'concave';
f_x = 0;
f_y = 0;
f_z = 0;

[~,source,mask] = kwave_simulation(n_r, n_y,A,B,D,[f_x,f_y,f_z],'R_focus',R_focus,...,
    'Slice',slice,'Dim',2);

figure; imagesc(source.p_mask);