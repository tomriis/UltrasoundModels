n_elements_r = 42;
n_elements_y = 6;
a = 90/1000;
b = 75/1000;
D = [4,6]/1000;
focus = [0,0,0];
data = zeros([81,276,276]);
data_sum = zeros([81,276,276]);

[max_hp, sum_hilbert, xdc_data]=...
horizontal_array_simulation(n_elements_r,n_elements_y, a*1000,...,
b*1000,D*1000,focus*1000,'R_focus',a*1000,'visualize_output',true);
