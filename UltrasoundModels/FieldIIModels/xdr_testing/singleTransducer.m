field_init(-1);

%% Set up medium & simulation:
c = 1490;  %(m/s) global speed of sound in medium
f0 = 650000;  %(Hz) center frequency of the transducer
fs = f0 * 20;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
%
Freq_att = 0.5*100/1e6;
att_f0 = 0.65e6;
att = Freq_att*att_f0;
set_field('c', c);
set_field('fs', fs);
set_field('att',att);
set_field('Freq_att',Freq_att);
set_field('att_f0',att_f0);
set_field('use_att',1);



load('/Users/tomriis/MATLAB/UltrasoundModels/UltrasoundModels/MatchingLayer22DScans.mat');
load('/Users/tomriis/MATLAB/UltrasoundModels/UltrasoundModels/MatchingLayer2Waveforms.mat');
scale = 0.177/0.17*0.1729/0.20;

% load('/Users/tomriis/MATLAB/UltrasoundModels/UltrasoundModels/2DScansNoMatchingLayer1.mat');
% load('/Users/tomriis/MATLAB/UltrasoundModels/UltrasoundModels/NoMatchingLayer1Waveforms.mat');
% scale = 1/1.3077;
h1 = figure;
for i = 1:3

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

cycles = 4; amplitude = scale*1.6*300000000/5;
excitation = amplitude * sin(2*pi*f0*(0 : (1/fs) : (cycles/f0)));

xdc_excitation(Tx, excitation);

%% Set measurement points
h = 0.2;
x = (-5:h:5)*1e-3;
y = x;
z = (7.5:h:80)*1e-3;
planes = {'xy','xz','yz'};
m = 4; n = 1;
p = 1;

    
    plane = planes{i};
    disp(plane)
    switch plane
        case 'xy'
            z = 10*1e-3;
            dimensions = [length(x), length(y)];
            focus = [0,0];
        case 'xz'
            y = 0;
            dimensions = [length(x), length(z)];
        case 'yz'
            x = 0;
            dimensions = [length(y), length(z)];
    end
    
    %create all individual x, y, z points within the above ranges
    [xv, yv, zv] = meshgrid(x, y, z);
    pos = [xv(:), yv(:), zv(:)];
    %% Calculate the emitted field at those points
    [hp, ~] = calc_hp(Tx, pos); %this is where the simulation happens
    %hp = hp/max(hp,[],'all');

%     if i == 2
%         timeField = reshape(hp, size(hp,1), dimensions(1), dimensions(2));
%         subplot(m,n,4);
%         plot(timeField(:, 25, 1),'DisplayName', 'Simulated'); hold on;
%         wv_end = 1200;
%         t1 = linspace(0,size(timeField,1),length(wv100(1:wv_end)));
%         plot(t1, wv100(1:wv_end)/cal*1e-6,'DisplayName', 'Measured');
%         legend;
%         ylabel('Pressure (Mpa)');
%         title('Waveform: With Matching Layer');
%     end
   
    max_hp = max(hp);
    max_hp = reshape(max_hp, dimensions(1), dimensions(2));
    switch plane
        case 'xy'
            x1 = x;
            y1 = y;
            
%             subplot(m,n,5);
%             imagesc(y1*1e3,x1*1e3,abs(xy)/cal*1e-6);
%             title('Measured PNP in xy Plane');
            xl = 'X (mm) [Z = 10]';
            yl = 'Y (mm)';
        case 'xz'
            x1 = x;
            y1 = z;
            xz2 = max_hp;
%             subplot(m,n,6);
%             imagesc(y1*1e3,x1*1e3,abs(xz')/cal*1e-6);
            title('Measured PNP in xz Plane');
            xl = 'Z (mm)';
            yl = 'X (mm)';
        case 'yz'
            x1 = y;
            y1 = z;
            yz2 = max_hp;
%             subplot(m,n,7);
%             imagesc(y1*1e3,x1*1e3,abs(yz')/cal*1e-6);
            title('Measured PNP in yz Plane');
            xl = 'Z (mm)';
            yl = 'Y (mm)';
    end
%             colormap('hot')
%             colorbar;
            maxC = max([max(abs(xy/cal*1e-6),[],'all'),...
                max(abs(xz/cal*1e-6),[],'all'),...
                max(abs(yz/cal*1e-6),[],'all')]);
%              maxC = max(max_hp,[],'all');
%             caxis([0 maxC]);
%             axis equal tight
            
%     xlabel(xl);
%     ylabel(yl);
    subplot(m,n,i);
    imagesc(y1*1e3,x1*1e3, max_hp);
    title(['Simulated PNP in ', plane,' Plane']); 
    xlabel(xl);
    ylabel(yl);
    colormap('hot');
    caxis([0 maxC]);
    colorbar;
    p = p + 1;
    axis equal tight
end

subplot(m,n,4);
plot(y1*1e3, abs(yz2(25,:)), 'DisplayName', 'Simulated'); hold on;%/max(abs(yz2(25,:))), 'r--'); hold on;
%plot(y1*1e3,abs(yz(1:length(y1),25))/cal*1e-6, 'DisplayName', 'Measured'); hold on;%/max(abs(yz(:,25)))); hold on; 
legend
xlabel('Z (mm)');
ylabel('Pressure (Mpa)');
title('Amplitude vs Distance From XDR');
set(h1,'color','w');
%% Terminate Field II
