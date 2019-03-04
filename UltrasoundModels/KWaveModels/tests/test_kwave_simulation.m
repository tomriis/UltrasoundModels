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

<<<<<<< HEAD
[~,source,mask,ijk] = kwave_simulation(n_r, n_y,A,B,D,[f_x,f_y,f_z],'R_focus',R_focus,...,
    'Slice',slice,'Dim',2,'type',type);
=======
[~,source,mask] = kwave_simulation(n_r, n_y,A,B,D,[f_x,f_y,f_z],'R_focus',R_focus,...,
    'Slice',slice,'Dim',2);
>>>>>>> f51a5980c9a941c06ac3aa8abb5728f0db659f52

figure; imagesc(source.p_mask);