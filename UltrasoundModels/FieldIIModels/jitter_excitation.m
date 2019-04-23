function [excitation] = jitter_excitation(total_cycles, number_of_cycles, frequencies)

iterations = floor(total_cycles/number_of_cycles);
excitation = [];
f0 = max(frequencies);
fs = 20*f0;
for i = 1:iterations
    curr= mod(i,length(frequencies))+1;
    f0 = frequencies(curr);
    ex_on = sin(2*pi*f0*(0 : (1/fs) : (number_of_cycles/f0)));
    excitation=horzcat(excitation, ex_on);
end
end