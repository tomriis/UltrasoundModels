outfile = './concave128.mat';

n_elements_r = 42;
n_elements_y = 6;
a = 90;
b = 75;
D = [4, 6];
R_focus = a;
Slice = {'xy','xz','yz'};

type = 'horizontal';

FX = [0, 20, 30, 40];
FY = [0];
FZ = [0, 20];

Dimensions = 3;
count = 1;
data = struct();
data1 = struct();
data2 = struct();
for i = 1:length(Slice)
    slice = Slice{i};
for x = 1:length(FX)
    f_x = FX(x);
    for y = 1:length(FY)
        f_y = FY(y);
        for z = 1:length(FZ)
            f_z = FZ(z);


focus = [f_x, f_y, f_z];
s = struct();
s.NR = n_elements_r; s.NY = n_elements_y; s.A=a; s.B=b; s.D = D;
s.Slice=slice; s.Ro=R_focus; s.FX = f_x; s.FY = f_y; s.FZ = f_z;
s.ElGeo = 2;


[sensor_data, kgrid] = kwave_simulation(n_elements_r,...,
    n_elements_y, a, b, D, focus,'R_focus',R_focus,...,
    'Slice',slice,'Dim',Dimensions,'type',type);

fname = fieldname_from_params(s);
data.(fname) = max(sensor_data,[],3);
data1.(fname) = sum(abs(hilbert(sensor_data)), 3);
data2.(fname) = max(abs(hilbert(sensor_data)),[], 3);
data.kgrid.Nx = kgrid.Nx;
data.kgrid.Ny = kgrid.Ny;
data.kgrid.Nz = kgrid.Nz;
data.kgrid.dx = kgrid.dx;
data.kgrid.dy = kgrid.dy;
data.kgrid.dz = kgrid.dx;
data.kgrid.t_array = kgrid.t_array;
data1.kgrid =data.kgrid;
data2.kgrid = data.kgrid;
clear sensor_data
clear kgrid
disp(strcat("ON simulation ", num2str(count)));
save(strcat(num2str(count),'.mat'),'-struct','data');
count = count +1;
        end
    end
end
end

save('s_h_kwave_max.mat','-struct','data');
save('s_h_kwave_max_hilbert.mat','-struct','data1');
save('s_h_kwave_sum_hilbert.mat','-struct','data2');

