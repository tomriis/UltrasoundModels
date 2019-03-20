outfile = './concave120R41Y6D6_8.mat';

n_elements_r = 41;
n_elements_y = 6;
a = 120;
b = 120;
D = [6,8];
R_focus = a;
Slice = {'xy','xz','yz'};

type = 'concave';

FX = [0, 20, 40];
FY = [0, 20];
FZ = [0, 20, 40];

Dimensions = 3;
count = 1;
data = struct();
for i = 1:length(Slice)
    slice = Slice{i};
for x = 1:length(FX)
    f_x = FX(x);
    for y = 1:length(FY)
        f_y = FY(y);
        for z = 1:length(FZ)
            f_z = FZ(z);
disp(strcat("ON simulation ", num2str(count)));
count = count +1;

focus = [f_x, f_y, f_z];
s = struct();
s.NR = n_elements_r; s.NY = n_elements_y; s.A=a; s.B=b; s.D = D;
s.Slice=slice; s.Ro=R_focus; s.FX = f_x; s.FY = f_y; s.FZ = f_z;
if strcmp(type, 'concave')
    s.ElGeo = 1;
elseif strcmp(type,'horizontal')
    s.ElGeo= 2;
end

[sensor_data, kgrid] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D, focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',Dimensions,'type',type);

fname = fieldname_from_params(s);
data.(fname) = 1;
data.(fname) = max(sensor_data,[],3);
data.kgrid.Nx = kgrid.Nx;
data.kgrid.Ny = kgrid.Ny;
data.kgrid.Nz = kgrid.Nz;
data.kgrid.dx = kgrid.dx;
data.kgrid.dy = kgrid.dy;
data.kgrid.dz = kgrid.dx;
data.kgrid.t_array = kgrid.t_array;
clear sensor_data

        end
    end
end
end

save(outfile,'-struct','data');

