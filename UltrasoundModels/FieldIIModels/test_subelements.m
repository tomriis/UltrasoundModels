c=1500;
f0 = 650e3;  %(Hz) center frequency of the transducer
fs = f0 * 20*2;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
field_init(-1);
set_field('c', c);
set_field('fs', fs);
set_field('att', alpha);

height=60/1000;
width=4/1000;
kerf=0;
N_elements=1;
no_sub_x=1;
no_sub_y=10;
focus=[0 0 1000]/1000;

Th = xdc_linear_array (N_elements, width, height, kerf,no_sub_x, no_sub_y, focus);

element_no=(1:N_elements)';
y=((0:(no_sub_y-1))-(no_sub_y-1)/2)/no_sub_y*height;
zf=30/1000;
basic_delay=(zf-sqrt(y.^2+zf.^2))/c;
delays=ones(N_elements,1)*reshape(ones(no_sub_x,1)*basic_delay,1, no_sub_x*no_sub_y);
ele_delay (Th, element_no, delays);
%xdc_focus(Th,0,focus);
%% Impulse response of a transducer (= acoustic pressure response emitted by a transducer when subjected to an electric dirac driving pulse)
fracBW = .50;  %fractional bandwidth of the xducer
tc = gauspuls('cutoff', f0, fracBW, -6, -40);  %cutoff time at -40dB, fracBW @ -6dB
t = -tc : 1/fs : tc;  %(s) time vector centered about t=0
impulse_response = gauspuls(t,f0,fracBW);
xdc_impulse(Th,impulse_response);

%% Driving waveform
excitation = 1;  % driving signel; 1 = simple pulse
xdc_excitation(Th, excitation);

%% Set measurement points
x = (-60 : 0.5 : 60)*1e-3;
y = (-60 : 0.5 : 60)*1e-3;
z = focus(3);
%create all individual x, y, z points within the above ranges
[xv, yv, zv] = meshgrid(x, y, z);
pos = [xv(:), yv(:), zv(:)];

%% Calculate the emitted field at those points
[hp, ~] = calc_hp(Th, pos); %this is where the simulation happens
txfield = max(hp);

txfield = reshape(txfield, length(x), length(y));
txfield = fliplr(txfield);

txfielddb = db(txfield./max(max(txfield)));

figure;
imagesc(x*1e3, y*1e3, txfielddb);
axis equal tight;
xlabel('x (mm)');
ylabel('y (mm)');
ch = colorbar; ylabel(ch, 'dB'); 
set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
figure;
show_xdc(Th)
field_end();

