clear
n_elements_r = 42;
n_elements_y = 6;
a = 90/1000;
b = 75/1000;
D = [4 4]/1000;
focus = [0,0,0];

frequencies = 650e3;%(550:100:750)*1e3;
total_cycles = 200;
on_cycles_list = 3;%[0.5,1,1.5, 2,2.5,3,3.5,4,4.5,5];
off_cycles_list = 2;%[1,2,3];
count = 1;

shift = linspace(0,pi/2,5);
jitter = [0,0.2,0.3];%[0, 0.1 , 0.2, 0.3, 0.4, 0.5, 0.6];
num_trials = 1;
total = length(frequencies)*length(num_trials)*length(jitter);
data = zeros(total,6);
data_fields = struct();
for j = 1:length(jitter)
for i = 1:length(total_cycles)
    for k = 1:num_trials
    on_cycles = 1;%on_cycles_list(i);
    for ofi = 1:length(off_cycles_list)
        off_cycles = on_cycles * off_cycles_list(ofi);
        for f_i = 1:length(frequencies)

        f0 = frequencies(f_i);
        fs = 20*f0;
        
%         excitation = duty_cycle_excitation(total_cycles,on_cycles,...,
%            off_cycles,f0,fs);
        excitation = sin(2*pi*f0*(0 : (1/fs) : (total_cycles(i)/f0)));

[hp, max_hp, sum_hilbert, xdc_data,y]=...
horizontal_array_simulation(n_elements_r,n_elements_y, a*1000,...,
b*1000,D*1000,focus*1000,'R_focus',a*1000,'visualize_output',true,...,
'excitation', excitation,'f0',f0);
title(strcat(["Jitter ",num2str(jitter(j))]));

txfield = max_hp./max(max(max_hp));%max_hp./max(max(max_hp));
           
profile = txfield(:, 276/2);

[pks,locs] = findpeaks(profile(length(profile)/2:end));



if abs(pks(1)- 1) < 0.15
    value = pks(2);
    location = y(276/2 + locs(2));
else
    value = pks(1);
    location = y(276/2 + locs(1));    
end
% data_fields.(strcat('f',num2str(j),num2str(k)))= max_hp;    
% peak_pressure = max(max(max_hp))*1e12;
% data(count,:) = [f0/1e5, total_cycles(i),jitter(j), peak_pressure, value, location];
count = count +1;
        end
        end   
        end
    end
end
