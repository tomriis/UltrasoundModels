function [excitation] = duty_cycle_excitation(total_cycles,...,
    on_cycles, off_cycles,f0,fs)

iterations = floor(total_cycles/(on_cycles+off_cycles));
excitation=[];
for i = 1:iterations
    ex = sin(2*pi*f0*(0 : (1/fs) : (on_cycles/f0)));
    ex_off = 0*(0:(1/fs):(off_cycles/f0));
    excitation = horzcat(excitation,ex,ex_off);
end

end
