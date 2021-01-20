n_elements_r = 32;
n_elements_z = 8;
a = 115/1000;
b = 95/1000;
D = [6 6]/1000;
focus = [25,0,0]/1000;
[x,y,z] = get_plane_xyz('xz', focus);
f0 = 200e3;
fs = 20*f0;
total_cycles = 20;
count = 1;
R_focus = 1.5*a;
kerf = 4.45/1000;

field_init(-1);
% [Th] = horizontal_array(32, 8, kerf, D, R_focus,a,b,[0+0.7,pi-0.7],1);


% % 

% [Th] = throughTransmitArray(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,0.5);
% data = xdc_pointer_to_rect(Th);
% % 
% figure; show_transducer('data',data); %,'plotEl',(1:256));
% field_end();
num_trials = 1;
data_fields = struct();
    
excitation = 1;%sin(2*pi*f0*(0 : (1/fs) : (total_cycles/f0)));

%figure; plot(excitation);
f0= 650000; fs = 20*f0;
    cycles = 10; amplitude = 300000000;
    excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));

[max_hp, sum_hilbert, xdc_data]=...
horizontal_array_simulation(n_elements_r,n_elements_z, a,...,
b,D,focus,'R_focus',R_focus,'kerf',kerf,...,
'plane','yz','excitation', excitation,'columnAngle',0.5,'visualize_transducer',false);
figure; imagesc(max_hp);
figure; show_transducer('data',xdc_data);

datag.max_hp= max_hp;
datag.xdc_data = xdc_data;
datag.x = x;
datag.y = y;
datag.z = z;
% 
h=figure; 
imagesc(x*1000,y*1000, datag.max_hp'./max(max(datag.max_hp)))
axis image;
xlabel('X (mm)');
ylabel('Y (mm)');
title('Simulated Field');
makeFigureBig(h,16);
