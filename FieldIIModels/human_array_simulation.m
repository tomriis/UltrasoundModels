function [txfielddb]=human_array_simulation(varargin)

default_element_W = 1.5;
expectedGeometries = {'focused','spherical','flat'};

p = inputParser;
addRequired(p,'n_elements', @(x) isnumeric(x));
addRequired(p,'ROC', @(x) isnumeric(x));
addRequired(p,'D');
addRequired(p, 'focal_point');
addOptional(p, 'AngleOfExtent', 0, @(x) isnumeric(x));
addOptional(p, 'P', default_element_W, @(x) isnumeric(x));
addOptional(p, 'element_geometry', 'flat', @(x) any(validatestring(x,expectedGeometries)));
addOptional(p, 'R_focus', 1e4, @(x) isnumeric(x));
addOptional(p, 'Nx', 4);
addOptional(p, 'Ny', 4);
addOptional(p,'visualize_transducer',false);
addOptional(p,'visualize_output',true);
parse(p, varargin{:})



%% Parameters to vary in this exercise
visualize_transducer = p.Results.visualize_transducer;
focal_point = p.Results.focal_point; %(mm) point of ultrasound focus relative to the top of the dome transducer array (Insightec Exablate Neuro system)
plane = 'xy'; %('xy' or 'xz'); the plane within which we visualize the pressure field

%% Initialize Field II:
field_init(-1);

%% Set up medium & simulation:
c = 1500;  %(m/s) global speed of sound in medium
f0 = 650e3;  %(Hz) center frequency of the transducer
fs = f0 * 20;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
%
set_field('c', c);
set_field('fs', fs);
set_field('att', alpha);

%% Linear concave array

ROC = p.Results.ROC; %mm
n_elements = p.Results.n_elements;  %number of physical elements.
AngExtent = p.Results.AngleOfExtent;
if AngExtent ~= 0 
    P = AngExtent * ROC / n_elements; %pitch (mm)
else
    P = p.Results.P;
end
D = p.Results.D; %Diameter, width, and length of element (mm)
Nx = p.Results.Nx; %number of mathematical subelements in x
Ny = p.Results.Ny; %number of mathematical subelements in y
element_geometry = p.Results.element_geometry;
R_focus = p.Results.R_focus;
Tx = concave_focused_array(n_elements, ROC/1000, P/1000, D/1000, R_focus/1000, Nx, Ny, element_geometry);

%Show the transducer array in 3D
if visualize_transducer
    show_xdc(Tx,'notfast');
    view([90, 90, 90]);    
    return;
end
%xdc_show(Tx); %this displays the coordinates of each element within the array

%% Impulse response of a transducer (= acoustic pressure response emitted by a transducer when subjected to an electric dirac driving pulse)
fracBW = .50;  %fractional bandwidth of the xducer
tc = gauspuls('cutoff', f0, fracBW, -6, -40);  %cutoff time at -40dB, fracBW @ -6dB
t = -tc : 1/fs : tc;  %(s) time vector centered about t=0
impulse_response = gauspuls(t,f0,fracBW);
xdc_impulse(Tx,impulse_response);
%
% Plot the impulse response
% plot(t*1e6, impulse_response); grid on; xlabel('t (\musec)');

%% Driving waveform
excitation = 1;  % driving signel; 1 = simple pulse
%
% if want to drive with a sine, use e.g.:
%cycles = 100; amplitude = 1;
%excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));
%
xdc_excitation(Tx, excitation);

%% Set focal point
focus = focal_point * 1e-3;  %(m)
delays = compute_delays(Tx, focus, c); %(s) The delay within which the ultrasound is fired from each of the array elements such as to achieve the desired focal point
%(could also use xdc_center_focus(Tx,[0 0 0]); xdc_focus(Tx, 0, focus) for physical element designs (e.g., dome tiled with xdc_rectangles()), instead of the mathematical xdc_concave)
%ele_delay(Tx, (1:n_elements)', delays); %set the delays
%xdc_center_focus(Tx, [0,0,focus(3)]);
xdc_focus(Tx, 0, focus);
%xdc_focus_times (Tx, 0, delays');

%% Set measurement points
switch plane
    case 'xy'
        x = (-60 : 0.5 : 60)*1e-3;
        y = x;
        z = -80e-3;
    case 'xz'
        x = (-60 : 0.5 : 60)*1e-3;
        y = 0;
        z = (0 : 0.5 : 120)*1e-3;
end
%create all individual x, y, z points within the above ranges
[xv, yv, zv] = meshgrid(x, y, z);
pos = [xv(:), yv(:), zv(:)];

%% Calculate the emitted field at those points
[hp, ~] = calc_hp(Tx, pos); %this is where the simulation happens

%% Plot the emitted field
%txfield = sum(abs(hilbert(hp)), 1); %Hilbert transform finds the envelop
%of the propagating pulse; summing it is a dirty way to approximate the amplitude of the signal regardless of the time it occurs at 
txfield = max(hp); %take the maximal value of the propagating pulse, and this way not have to worry about at which time point the pulse arrived to the given location
%reshape the output for 2D plotting
switch plane
    case 'xy'
        txfield = reshape(txfield, length(x), length(y));
        txfield = fliplr(txfield); %flip the x coordinate for proper orientation
    case 'xz'
        txfield = reshape(txfield, length(x), length(z));
        txfield = txfield'; %flip the z coordinate for proper orientation
end
txfielddb = db(txfield./max(max(txfield))); %convert to dB (Voltage i.e. 20 log_10 (txfield/MAX) )

if p.Results.visualize_output
    figure;
    switch plane
        case 'xy'
            imagesc(x*1e3, y*1e3, txfielddb);
            axis equal tight;
            xlabel('x (mm)');
            ylabel('y (mm)');
            ch = colorbar; ylabel(ch, 'dB'); 
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            figure;
            XL = 60; plot(x*1e3, txfielddb(round(length(txfielddb) / 2), :)); xlim([-XL XL]); hold on; plot([-XL, XL], [-6 -6], 'k--', 'linewidth', 2);
            xlabel('x (mm)');
        case 'xz'
            imagesc(x*1e3, z*1e3, txfielddb); colorbar;
            xlabel('x (mm)');
            ylabel('z (mm)');
            ch = colorbar; ylabel(ch, 'dB');        
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            figure;
            ZL1 = 0; ZL2 = 120; plot(z*1e3, txfielddb(:, round(length(txfielddb) / 2))); xlim([ZL1 ZL2]); hold on; plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
            xlabel('z (mm)');
    end
    ylabel('Pressure (dB)');
    set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
end

%% Terminate Field II
field_end();