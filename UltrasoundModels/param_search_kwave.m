outfile = './concaveR41Y6F40.mat';

n_elements_r = 41;
n_elements_y = 6;
a = 120;
b = 120;
D = [6,8];
R_focus = a;
slice = 'xy';
type = 'concave';

f_x = 40;
f_y = 0;
f_z = 0;
focus = [f_x, f_y, f_z];
Dimensions = 3;

s = struct();
s.NR = n_elements_r; s.NY = n_elements_y; s.A=a; s.B=b; s.D = D;
s.Slice=slice; s.Ro=R_focus; s.FX = f_x; s.FY = f_y; s.FZ = f_z;
if strcmp(type, 'concave')
    s.ElGeo = 1;
elseif strcmp(type,'horizontal')
    s.ElGeo= 2;
end
data = struct();

[sensor_data, kgrid] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D, focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',Dimensions,'type',type);

fname = fieldname_from_params(s);

data.(fname) = sensor_data;
data.kgrid = kgrid;

save(outfile,'-struct','data');


