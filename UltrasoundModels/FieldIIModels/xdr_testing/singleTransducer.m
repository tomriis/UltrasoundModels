field_init(-1);

%% Set up medium & simulation:
c = 1490;  %(m/s) global speed of sound in medium
f0 = 650000;  %(Hz) center frequency of the transducer
fs = f0 * 20;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
%
set_field('c', c);
set_field('fs', fs);
set_field('att', alpha);

h1 = figure;
for i = 1:length(planes)

D = [6, 6]*1e-3;
x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];

rect = [1 x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
cent = [0,0,0];
Tx = xdc_rectangles(rect, cent, [0,0,0]); 
%% Impulse response of a transducer 
% (= acoustic pressure response emitted by a transducer 
% when subjected to an electric dirac driving pulse)
fracBW = .25;  %fractional bandwidth of the xducer
tc = gauspuls('cutoff', f0, fracBW, -6, -40);  
%cutoff time at -40dB, fracBW @ -6dB

t = -tc : 1/fs : tc;  %(s) time vector centered about t=0
impulse_response = gauspuls(t,f0,fracBW);
xdc_impulse(Tx,impulse_response);

% Plot the impulse response
%figure; plot(t*1e6, impulse_response); grid on; xlabel('t (\musec)');

cycles = 4; amplitude = 300000000;
excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));

xdc_excitation(Tx, excitation);

%% Set measurement points
h = 0.2;
x = (-5:h:5)*1e-3;
y = x;
z = (7.5:h:30)*1e-3;
planes = {'xy','xz','yz'};
m = 2; n = 3;
p = 1;

    
    plane = planes{i};
    disp(plane)
    switch plane
        case 'xy'
            z = 7.5*1e-3;
            dimensions = [length(x), length(y)];
            focus = [0,0];
        case 'xz'
            y = 0;
            dimensions = [length(x), length(z)];
        case 'yz'
            x = 0;
            dimensions = [length(y), length(z)];
    end
    if strcmp('xy',plane)
        [~, focusPoint(1)] = min(abs(x - 0));
        [~, focusPoint(2)] = min(abs(y - 0));
    else
        [~, focusPoint(1)] = min(abs(x - 0));
        [~, focusPoint(2)] = min(abs(z - 10e-3));
    end
    %create all individual x, y, z points within the above ranges
    [xv, yv, zv] = meshgrid(x, y, z);
    pos = [xv(:), yv(:), zv(:)];
    %% Calculate the emitted field at those points
    [hp, ~] = calc_hp(Tx, pos); %this is where the simulation happens
    %hp = hp/max(hp,[],'all');

    if i == 1
        timeField = reshape(hp, size(hp,1), dimensions(1), dimensions(2));
        subplot(m,n,4);
        plot(timeField(:, focusPoint(1), focusPoint(2)));
    end
    subplot(m,n,i);
    max_hp = max(hp);
    max_hp = reshape(max_hp, dimensions(1), dimensions(2));
    switch plane
        case 'xy'
            x1 = x;
            y1 = y;
        case 'xz'
            x1 = x;
            y1 = z;
        case 'yz'
            x1 = y;
            y1 = z;
    end
    imagesc(y1*1e3,x1*1e3, max_hp);
    colormap('hot');
    colorbar;
    p = p + 1;
    axis equal tight
end
%% Terminate Field II
