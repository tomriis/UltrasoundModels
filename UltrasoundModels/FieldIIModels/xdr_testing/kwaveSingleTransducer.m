

%% Define Single Transducer
D = [6, 6]*1e-3;
z_val = 20/1000;
x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [z_val,z_val];

rect = [1 x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  z_val];
cent = [0,0,z_val];
field_init(-1)
Th = xdc_rectangles(rect, cent, [0,0,0]);
rect = xdc_pointer_to_rect(Th);
show_transducer('Th',Th);
field_end();
%%
Dimensions = 3; 
focus = [0,0,0];
slice = 'xy';
gridXYZ = [0.006,0.006,0.025];


[sensor_data,source,sensor, kgrid]= kwave_simulation(rect,Dimensions, focus, slice, gridXYZ);
data_t = reshape(sensor_data, [size(sensor.mask), length(kgrid.t_array)]);
data = max(abs(data_t),[],4);

%% Dataviz
kWaveSingleTransducerDataviz;



