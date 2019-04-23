function [hp,max_hp, sum_hilbert, xdc_data,y]=horizontal_array_simulation(varargin)

p = inputParser;
addRequired(p,'n_elements_r', @(x) isnumeric(x));
addRequired(p,'n_elements_z', @(x) isnumeric(x));
addRequired(p,'a', @(x) isnumeric(x));
addRequired(p,'b', @(x) isnumeric(x));
addRequired(p,'D');
addRequired(p, 'focal_point');
addOptional(p, 'kerf',0.4);
addOptional(p, 'R_focus', 1e15, @(x) isnumeric(x));

addOptional(p,'visualize_transducer',false);
addOptional(p,'visualize_output',true);
addOptional(p,'Slice','xy');
addOptional(p,'excitation',-1);
addOptional(p,'f0',650000)
parse(p, varargin{:})

%% Due to memory issue, must define transducer in vertical direction
%% and transform focus and measurement plane to horizontal direction

y_to_z_transform = [1 0 0; 0 0 1; 0 1 0];


%% Parameters to vary in this exercise
visualize_transducer = p.Results.visualize_transducer;
focal_point = p.Results.focal_point; %(mm) point of ultrasound focus relative to the top of the dome transducer array (Insightec Exablate Neuro system)
if size(focal_point,2) == 1
    focal_point = focal_point';
end
%focal_point = (y_to_z_transform*focal_point)';
plane = p.Results.Slice; %('xy' or 'xz'); the plane within which we visualize the pressure field

%% Initialize Field II:
field_init(-1);

%% Set up medium & simulation:
c = 1500;  %(m/s) global speed of sound in medium
f0 = p.Results.f0;  %(Hz) center frequency of the transducer
fs = f0 * 20;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
%
set_field('c', c);
set_field('fs', fs);
set_field('att', alpha);

%% Linear concave array

a = p.Results.a; %mm
b = p.Results.b;
n_elements_r = p.Results.n_elements_r;  %number of physical elements in X.
n_elements_z = p.Results.n_elements_z;  %number of physical elements in Y.
kerf = p.Results.kerf;
D_rz = p.Results.D; %Diameter, width, and length of element (mm)
R_focus = p.Results.R_focus;
[Tx] = horizontal_array(n_elements_r,n_elements_z, kerf/1000, D_rz/1000, R_focus/1000, a/1000, b/1000);

%Show the transducer array in 3D
if visualize_transducer
    xdc_data = xdc_get(Tx,'rect');
    show_transducer('data',xdc_data);
    txfield = 0;
    return
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
if p.Results.excitation == -1
    excitation = 1;  % driving signel; 1 = simple pulse
%
% if want to drive with a sine, use e.g.:
%cycles = 1; amplitude = 1;
%excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));
%excitation = duty_cycle_excitation(total_cycles, number_of_cycles, duty_cycle);
else    
    excitation = p.Results.excitation;
%     figure; plot(excitation);
%                      % Sampling period       
% L = length(excitation);       % Length of s
% Y = fft(excitation);
% P2 = abs(Y/L);
% P1 = P2(1:round(L/2)+1);
% P1(2:end-1) = 2*P1(2:end-1);
%         f = fs*(0:(L/2))/L;
%         figure;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
end
%
% hp=0;max_hp=0; sum_hilbert=0; xdc_data=0; y=0;
% return;
xdc_excitation(Tx, excitation);

%% Set focal point
focus = focal_point * 1e-3;  %(m)

%delays = compute_delays(Tx, focus, c, n_elements, Nx, Ny); %(s) The delay within which the ultrasound is fired from each of the array elements such as to achieve the desired focal point
%(could also use xdc_center_focus(Tx,[0 0 0]); xdc_focus(Tx, 0, focus) for physical element designs (e.g., dome tiled with xdc_rectangles()), instead of the mathematical xdc_concave)

%delays=repmat(delays,1,Nx*Ny);

%ele_delay(Tx, 1, delays(1,:)); %set the delays
%xdc_center_focus(Tx, [0,0,0]);
xdc_focus(Tx, 0, focus);
%xdc_focus_times (Tx, 0, delays);
%% Set measurement points
[x,y,z] = get_slice_xyz(plane, focus);
%create all individual x, y, z points within the above ranges
[xv, yv, zv] = meshgrid(x, y, z);
pos = [xv(:), yv(:), zv(:)];

%% Calculate the emitted field at those points
[hp, ~] = calc_hp(Tx, pos); %this is where the simulation happens

xdc_data = xdc_get(Tx,'rect');
%% Plot the emitted field

sum_hilbert = sum(abs(hilbert(hp)), 1); %Hilbert transform finds the envelop
%of the propagating pulse; summing it is a dirty way to approximate the amplitude of the signal regardless of the time it occurs at 
max_hp = max(hp); %take the maximal value of the propagating pulse, and this way not have to worry about at which time point the pulse arrived to the given location
max_hilbert = max(abs(hilbert(hp)));

size(sum_hilbert)
length(x)
length(y)
sum_hilbert = reshape(sum_hilbert, 276, 276);
max_hilbert = reshape(max_hilbert, 276, 276);
max_hp = reshape(max_hp, 276, 276);
%reshape the output for 2D plotting

   
try
if p.Results.visualize_output
    figure;
    switch plane
        case 'xy'
            txfielddb = db(max_hp./max(max(max_hp)));
            imagesc(x*1e3, y*1e3, txfielddb);
            axis equal tight;
            xlabel('x (mm)');
            ylabel('y (mm)');
            ch = colorbar; ylabel(ch, 'dB'); 
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            figure;
            XL = min(x)*1e3;
            XH = max(x)*1e3;
            profile = txfielddb(:, 276/2);
            plot(x*1e3, profile); 
            xlim([XL XH]); hold on; plot([XL, XH], [-6 -6], 'k--', 'linewidth', 2);
            xlabel('y (mm)');
        case 'xz'
            imagesc(x*1e3, z*1e3, txfielddb); colorbar;
            xlabel('x (mm)');
            ylabel('z (mm)');
            ch = colorbar; ylabel(ch, 'dB');        
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            figure;
            ZL1 = min(z)*1000; ZL2 = max(z)*1000; plot(z*1e3, txfielddb(:, (x==focus(1)))); xlim([ZL1 ZL2]); hold on; plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
            xlabel('z (mm)');
        case 'yz' 
            imagesc(y*1e3, z*1e3, txfielddb); colorbar;
            xlabel('y (mm)');
            ylabel('z (mm)');
            ch = colorbar; ylabel(ch, 'dB');        
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            figure;
            %Adjust for changing focus in x and y direction . map to
            %indexes
            ZL1 = min(z)*1000; ZL2 = max(z)*1000; plot(z*1e3, txfielddb(:, round(length(txfielddb) / 2))); xlim([ZL1 ZL2]); hold on; plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
            xlabel('z (mm)');
    end
    ylabel('Pressure (dB)');
    set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
end
catch 
end
%% Terminate Field II
field_end();