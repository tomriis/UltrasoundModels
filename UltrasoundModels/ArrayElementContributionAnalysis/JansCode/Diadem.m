function [allrect, txfieldmax,fieldDim] = Diadem(Nw, Nh, Rw, Rh, focus, distanceFromSagitalPlane, outputdim, dualArrayFlag,varargin)
if isempty(varargin)
    planeCoordinates = [0,0,0];
    planeVolume = [[-30,30];
                    [-30,30];
                    [-30,30]];
else
    planeCoordinates = varargin{1};
    planeVolume = varargin{2};
    disp(planeCoordinates);
    disp(planeVolume);
end
%% Parameters to vary in this exercise
arraytype = 'pistonfocused';
arraymodel = 'Diadem'; %'206', '173', '104', '115', 'Diadem'
fracBW = 0.68;  %fractional bandwidth is important for peak power (lower values works better (undampened transducer))
visualize_transducer = 0;
drivewith = 'sine'; %'pulse' or 'chirp' or 'sine' or 'randomfm' or 'randomfmsmooth'
% outputdim = 'xz'; %('line' or 'xz' or 'xy'); the outputdim within which we visualize the pressure field
propagationmovie = 0;

%% Initialize Field II:
field_init(-1);

%% Set up medium & simulation:
c = 1500;  %(m/s) global speed of sound in medium

f0 = 650e3;  %(Hz) center frequency of the transducer
fs = f0 * 25;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5;  %(dB/cm/MHz) attenuation of ultrasound in the brain
%
set_field('c', c);
set_field('fs', fs);
set_field('use_att', true); set_field('att', alpha * 100 * f0/1e6);

%% Arrays
% focus = [-10 0 -15] * 1e-3;
    %spherical arrays

    Rcurvature = Rh; %m
    Rfocus = Rw;
    %the larger the aperture (either larger dims or larger kerf, the
    %smaller the F#, and so the more the array focuses):
    kerf = 0.0; %don't need kerf
    %
    allrect = [];
    allcent = [];
    %
    xcordsi = [2, 5, 8, 11, 17]; 
    zcordsi = [4, 7, 10, 13, 19]; %for rectangles
    %first transducer
    [rectangles, cent] = concave_focused_array_rectonly(Nh, Nw, Rcurvature, kerf, [6, 6]/1000, Rfocus);
    %
    
    translz = distanceFromSagitalPlane-Rcurvature; %optional translation in z
    rectangles(zcordsi, :) = rectangles(zcordsi, :) + translz;
    cent(3, :) = cent(3, :) + translz;
    %
    allrect = [allrect; rectangles'];
    allcent = [allcent; cent'];
    %
    %2nd, opposing transducer
    if dualArrayFlag
        rectangles(zcordsi, :) = - rectangles(zcordsi, :);
        rectangles(1, :) = size(allrect, 1) + 1 : size(allrect, 1) + size(rectangles, 2);
        cent(3, :) = -cent(3, :);
        allrect = [allrect; rectangles'];
        allcent = [allcent; cent'];
    end
%     size(allrect)
%     m = [];
%     y = (1:14:126);
%     column = [7:8]-1;
%     for i = 1:length(column);
%         m = horzcat(m,column(i)+y);
%     end
%     rows = [5];
%     x = (1:14);
%     for j = 1:length(rows)
%         m = horzcat(m,(rows(j)-1)*14+x);
%     end
% %     m = [5+y; 6+y; 7+y;8+y;9+y];
%     inds1 = m(:);
% %     mnot = (1:126)';
% %     mnot(inds1) = [];
%     inds2 =inds1+126;
% %     inds1 = inds2 - 126;
%     allrect([inds1;inds2],:)=[];
%     allrect(:,1) = 1:length(allrect);
    Tx = xdc_rectangles(allrect, allcent, focus);


%% Impulse response of a transducer (= acoustic pressure response emitted by a transducer when subjected to an electric dirac driving pulse)
    tc = gauspuls('cutoff', f0, fracBW, -3, -40);  %fracBW @ -3dB; cutoff time at -40dB
    t = -tc : 1/fs : tc;  %(s) time vector centered about t=0
    impulse_response = gauspuls(t,f0,fracBW);
    xdc_impulse(Tx, impulse_response);
%
% Plot the impulse response
% plot(t*1e6, impulse_response); grid on; xlabel('t (\musec)');

%% Driving waveform
cycles = 100;
amplitude = 1;
t = (1/fs : (1/fs) : (cycles/f0));
for i=1:length(t)
    if mod(t(i),2.7692e-05) < 4.6154e-06
        a(i) = 1;
    else 
        a(i) = 0;
    end
end
tL = numel(t);
f1 = f0 * (1 - fracBW / 2); %starting frequency of the chirp
f2 = f0 * (1 + fracBW / 2); %ending frequency
%         f1 = f0 * 0.9; %starting frequency of the chirp
%         f2 = f0 * 1.1; %ending frequency
cycleswithsamefreq = 4; %5 is a good compromise between power and width; above, width suffers; below, power suffers
switch drivewith
    case 'pulse'
        onesegment = 1;
    case 'chirp'
        f = f1 : (f2 - f1) / (tL - 1) : f2;
        onesegment = amplitude * sin(2*pi*f.*t);
    case 'sine'
        f = f0 * ones(size(t));
        onesegment = amplitude * sin(2*pi*f.*t); %.* a;
    case 'randomfm' %has slightly better resolution but slightly less power
        instant_frequency_for_cycle = f1 + (f2 - f1) * rand(1, cycles / cycleswithsamefreq); %uniform frequencies between f1 and f2
        %        instant_frequency_for_cycle = f0 + (f2 - f1) / 4 * randn(1, cycles / cycleswithsamefreq); %gaussian frequencies between f1 and f2 - not as good (doesn't make use of bandwidth)
        f = repelem(instant_frequency_for_cycle, cycleswithsamefreq * fs / f0);
        onesegment = amplitude * sin(2*pi*f.*t);
    case 'randomfmsmooth' %without temporal disconnects between segments
        onesegment = [];
        while numel(onesegment) < tL
            cf = f1 + (f2 - f1) * rand(1); %frequency between f1 and f2
            f = cf * ones(1, floor(fs / cf));
            ct = 1/fs : 1/fs : 1/cf;
            sig = amplitude * sin(2*pi*f.*ct);
            for cc = 1 : cycleswithsamefreq
                onesegment = cat(2, onesegment, sig);
            end
        end
        onesegment(tL + 1 : end) = []; %chop of for exact comparison with the other methods
end
K = 1; %number of repetitions (for chirp; stiching the waves from high to low); this is good to keep at 1 and set cycles to the total duration of the stimulus
excitation = zeros(1, K * tL);
for k = 1 : K
    excitation((k - 1) * tL + 1 : k * tL) = onesegment;
    onesegment = -fliplr(onesegment); %it's beneficial to flip (start with the frequency the last segment ended) else there are additional sidelobes
end

%excitation = 1;  % driving signal; 1 = simple pulse
xdc_excitation(Tx, excitation);

%% Set focal point
xdc_center_focus(Tx, focus);

xdc_focus(Tx, 0, focus);


%% Show the transducer array in 3D
if visualize_transducer
    xdc_show(Tx);  %#ok<UNRCH>
    show_xdc(Tx);
    zlim([-150, 150]);
    view([90, 90, 90]);
    return;
end

%% Set measurement points
res = 0.25; %grid resolution in mm
switch outputdim  
    case 'yz'
        x = planeCoordinates(1);
        y = planeCoordinates(2)+(planeVolume(2,1): res:planeVolume(2,2));
        z = planeCoordinates(3)+(planeVolume(3,1):res:planeVolume(3,2));
    case 'xy'
        x = planeCoordinates(1)+(planeVolume(1,1) : res : planeVolume(1,2));
        y = planeCoordinates(2)+(planeVolume(2,1) : res : planeVolume(2,2));
%        y = x;
        z = planeCoordinates(3);
%         z = 60e-3;
    case 'xz'
        x = planeCoordinates(1)+(planeVolume(1,1) : res : planeVolume(1,2));
        y = planeCoordinates(2);
        z = planeCoordinates(3)+(planeVolume(3,1) : res : planeVolume(3,2));
    case 'line'
        x = focus(1);
        y = focus(2);
        z = (-55 : 0.1 : 55)*1e-3;
end
x = x*1e-3;
y = y*1e-3;
z = z*1e-3;
%create all individual x, y, z points within the above ranges
[xv, yv, zv] = meshgrid(x, y, z);
pos = [xv(:), yv(:), zv(:)];

%% Calculate the emitted field at those points
[hp, ~]=calc_hp(Tx, pos); %this is where the simulation happens

% txfield = mean(hp.^2, 1); %overall average energy (normalized per time)
%     txfield = mean(abs(hp), 1); %overall average energy (normalized per time)
%     txfield = mean(hp.^2, 1); %overall average energy (normalized per time)
%     txfield = sum(hp.^2, 1); %overall energy (intensity integrated over time)
    txfield = max(hp, [], 1); %max pressure over time

   


%% Plot the emitted field
switch outputdim
    case 'xy'
        txfield = reshape(txfield, numel(y), numel(x));
    case 'yz'
        txfield = reshape(txfield,numel(y),numel(z)); 
    otherwise
        txfield = reshape(txfield, numel(x), numel(z));
end
txfieldmax = txfield;
 %convert to dB:
    txfield = txfield / max(max(txfield));
    txfield = 20 * log10(txfield);
    fieldDim = {x,y,z};
% set(gcf,'position', [   1           1        2560        1344]);
% set(gcf,'position', [1           1        1680         954]);

%     switch outputdim
%         case 'line'
%             hold on;
%             set(gcf, 'position', [1 1 1680 954]);
%             plot(z * 1000, txfield);
%             hold on;
%             xlabel('z (mm)');
%             ylabel('Pressure');
%             set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
%             env = findenv(z, txfield);
%             plot(z * 1000, env, 'k:');
%             fwhmv = fwhm(env, z * 1000, false);
%             fprintf('FWHM = %.1f mm\n', fwhmv);
%         case 'xz'
%             imagesc(z*1e3, x*1e3, txfield); colorbar;
%             axis equal;
%             ylabel('x (mm)');
%             xlabel('z (mm)');
%             ch = colorbar; ylabel(ch, 'Out');
%             set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
%         case 'xy'
%             imagesc(x*1e3, y*1e3, txfield); colorbar;
%             axis equal;
%             ylabel('x (mm)');
%             xlabel('y (mm)');
%             ch = colorbar; ylabel(ch, 'Out');
%             set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
%     end



%% Terminate Field II



% %%-------------
% function yout = findenv(x, y)
% x = x(:);
% y = y(:);
% [pks, locs] = findpeaks(abs(y), x, 'MinPeakDist', 1e-3);
% %ylin = interp1(locs, pks, x, 'spline');
% ylin = interp1(locs, pks, x);
% yout = ylin;