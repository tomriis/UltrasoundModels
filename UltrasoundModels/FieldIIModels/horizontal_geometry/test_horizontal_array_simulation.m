n_elements_r = 14;
n_elements_z = 7;
a = 100/1000;
b = 80/1000;
D = [9 9]/1000;
focus = [30,0,0]/1000;
[x,y,z] = get_plane_xyz('xz', focus);
f0 = 200e3;
fs = 20*f0;
total_cycles = 20;
count = 1;
R_focus = 1.25*a;
kerf = 1/1000;

field_init(-1);
[Th] = horizontal_array(43, 6, kerf, D, R_focus,a,b,[0+1.24,pi-1.24],1000);

% [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, 100*R_focus,a,b,[0+1.24,pi-1.24],1000);
% data1 = xdc_pointer_to_rect(Th);
% [Th] = horizontal_array([12,12], n_elements_z, kerf, D, R_focus,a,b,[0.5,1.12;pi-1.12,pi-0.5],0);
% data2 = xdc_pointer_to_rect(Th);
% 
% data = horzcat(data1, data2);
% data(1,:) = 1:length(data);
% [Th] = throughTransmitArray(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,1000);
data = xdc_pointer_to_rect(Th);
figure; show_transducer('data',data,'plotEl',(1:256));
field_end();
% num_trials = 1;
% data_fields = struct();
%     
% excitation = 1;%sin(2*pi*f0*(0 : (1/fs) : (total_cycles/f0)));
% 
% %figure; plot(excitation);
% [max_hp, sum_hilbert, xdc_data]=...
% horizontal_array_simulation(n_elements_r,n_elements_y, a*1000,...,
% b*1000,D*1000,focus*1000,'R_focus',a*1000,'kerf',6,...,
% 'Slice','xz','excitation', excitation,'visualize_transducer',false);
% 
% datag.max_hp= max_hp./(max(max_hp,[],'all'));
% datag.xdc_data = xdc_data;
% datag.x = x;
% datag.y = y;
% datag.z = z;