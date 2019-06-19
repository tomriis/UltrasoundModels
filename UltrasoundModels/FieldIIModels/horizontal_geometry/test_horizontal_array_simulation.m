clear
n_elements_r = 43;
n_elements_y = 6;
a = 118/1000;
b = 90/1000;
D = [6 6]/1000;
focus = [0,0,0];
[x,y,z] = get_slice_xyz('xy', focus);
frequencies = [550,650, 750]*1e3;
f0 = 650e3;
fs = 20*f0;
total_cycles = 1036;
on_cycles_list =  32;%[32, 64, 128, 256];%[0.5,1,1.5, 2,2.5,3,3.5,4,4.5,5];
off_cycles_list = [0,0.25,0.5,1];%[1,2,3];
count = 1;


%jitter = [0,0.2,0.3];%[0, 0.1 , 0.2, 0.3, 0.4, 0.5, 0.6];
num_trials = 1;
total = length(on_cycles_list)*length(off_cycles_list);
data = zeros(total,6);
data_fields = struct();
figure;
for i = 1:length(on_cycles_list)
    on_cycles = on_cycles_list(i);
        for ofi = 1:length(off_cycles_list)
            off_cycles = on_cycles * off_cycles_list(ofi);
            excitation = duty_cycle_jitter_excitation(total_cycles,...,
                            on_cycles, off_cycles, frequencies);
%           
%         excitation = duty_cycle_excitation(total_cycles,on_cycles,...,
%            off_cycles,f0,fs);
%         excitation = sin(2*pi*f0*(0 : (1/fs) : (total_cycles/f0)));
DC = on_cycles/(off_cycles+on_cycles);
disp(DC);
%figure; plot(excitation);
[max_hp, sum_hilbert, xdc_data]=...
horizontal_array_simulation(n_elements_r,n_elements_y, a*1000,...,
b*1000,D*1000,focus*1000,'R_focus',a*1000,'visualize_transducer',true);
%  title(strcat(["On Cycles: ", num2str(on_cycles)]));

subplot(2,4,count)
txfielddb = db(sum_hilbert./max(max(sum_hilbert)));
            imagesc(x*1e3, y*1e3, txfielddb);
            axis equal tight;
%             xlabel('x (mm)');
%             ylabel('y (mm)');
            ch = colorbar; %ylabel(ch, 'dB'); 
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            title(strcat(["DC: ", num2str(DC)]));
            subplot(2,4,count+4)
            XL = min(x)*1e3;
            XH = max(x)*1e3;
            profile = txfielddb(:, 276/2);
            plot(x*1e3, profile); 
            xlim([XL XH]); hold on; plot([XL, XH], [-6 -6], 'k--', 'linewidth', 2);
            xlabel('y (mm)');
            hold on;
% % 
% [pks,locs] = findpeaks(profile(length(profile)/2:end));
% 
% 
% 
% if abs(pks(1)- 1) < 0.15
%     value = pks(2);
%     location = y(276/2 + locs(2));
% else
%     value = pks(1);
%     location = y(276/2 + locs(1));    
% end
% data_fields.(strcat('f',num2str(j),num2str(k)))= max_hp;    
% peak_pressure = max(max(max_hp))*1e12;
% data(count,:) = [f0/1e5, total_cycles(i),jitter(j), peak_pressure, value, location];
count = count +1;
        
    end
end
