frequencies= unique(data(:,1));

freq = 6.5;
inds = data(:,1) == freq;
data_f = data( inds,:);

dc = data_f(:,2)./(data_f(:,2)+data_f(:,3));

dc_vals = unique(dc);
lines = {'--',':','-.'};
figure;
for i = 1:length(dc_vals)
    dc_inds = dc == dc_vals(i);
    plot(data_f(dc_inds,2),db(data_f(dc_inds,4)),strcat(lines{i},'o'),'LineWidth',2, 'DisplayName',...,
        strcat("Duty Cycle ",num2str(dc_vals(i)))); hold on;
end
legend;
title(num2str(freq));
ylabel('Grating Lobes Pressure (dB)');
xlabel('# of Half Cycles On');
title('Grating Lobes in Y Dimension (Jitter)');
hold off;



figure;
n_cycles = unique(data(:,2));

cycles_inds = data(:,2) == 2.5;
data_c = data(cycles_inds,:);
    
    dc = data_c(:,2)./(data_c(:,2)+data_c(:,3));
    dc_vals = unique(dc);
   
    for i = 1:length(dc_vals)
        dc_inds = dc == dc_vals(i);
        plot(data_c(dc_inds,1),data_c(dc_inds,5), 'DisplayName',...,
            strcat("DC ",num2str(dc_vals(i)))); hold on;
    end
ylabel('Grating Lobe Distance');
xlabel('Frequency');
legend;
hold off;



