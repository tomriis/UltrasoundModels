function [excitation] = duty_cycle_jitter_excitation(total_cycles,...,
                            on_cycles, off_cycles, frequencies)

iterations = floor(total_cycles/(on_cycles+off_cycles));
excitation = [];
f0 = max(frequencies);
fs = 20*f0;
    for i = 1:iterations
        curr= mod(i,length(frequencies))+1;
        f0 = frequencies(curr);
        ex = sin(2*pi*f0*(0 : (1/fs) : (on_cycles/f0)));
        ex_off = 0*(0:(1/fs):(off_cycles/f0));
        excitation = horzcat(excitation,ex,ex_off);

    end
end

