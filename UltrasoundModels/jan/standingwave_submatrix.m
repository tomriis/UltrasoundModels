function standingwave_submatrix()

%% Parameters to vary
arraytype = 'pistonfocused';
arraymodel = 'Diadem'; %'206', '173', '104', '115', 'Diadem'
fracBW = 0.68;  %fractional bandwidth is important for peak power (lower values works better (undampened transducer))
visualize_transducer = 0;
drivewith = 'pulse'; %'pulse' or 'chirp' or 'sine' or 'randomfm' or 'randomfmsmooth'
outputdim = 'xz'; %('line' or 'xz' or 'xy'); the outputdim within which we visualize the pressure field
propagationmovie = 0;

%% Initialize Field II:
field_init(-1);

%% Set up medium & simulation:
c = 1500;  %(m/s) global speed of sound in medium
switch arraymodel
    case 'Diadem'
        f0 = 650e3;  %(Hz) center frequency of the transducer
    case 'H-115'
        f0 = 270e3;  %(Hz) center frequency of the transducer
    case 'H-104'
        f0 = 500e3;  %(Hz) center frequency of the transducer
    case 'H-173'
        f0 = 800e3;  %(Hz) center frequency of the transducer
    case 'H-206'
        f0 = 400e3;  %(Hz) center frequency of the transducer
end
fs = f0 * 50;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5;  %(dB/cm/MHz) attenuation of ultrasound in the brain
%
set_field('c', c);
set_field('fs', fs);
set_field('use_att', true); set_field('att', alpha * 100 * f0/1e6);

%% Arrays
focus = [0 0 0] * 1e-3;

numels = 11; %needs to be an odd number, else issues

switch arraytype
    case 'rectangularflat'
        %rectangular arrays
        D = 20e-3; %element width
        R = D/2;
        Z = 60e-3;
        ztr = Z; %how far from focus
        center1 = [0, 0, ztr];
        rect1 = [1, R, R, ztr, R, -R, ztr, -R, -R, ztr, -R, R, ztr, 1, 2*R, 2*R, center1(1), center1(2), center1(3)];
        ztr = -Z; %how far from focus
        center2 = [0, 0, ztr];
        rect2 = [2, R R ztr, R -R ztr, -R -R ztr, -R R ztr, 1, 2*R, 2*R, center2(1), center2(2), center2(3)];
        ztr = Z;
        center3 = [ztr, 0, 0];
        %         rect3 = [3, ztr R R, ztr R -R, ztr -R -R, ztr -R R, 1, 2*R, 2*R, center3(1), center3(2), center3(3)];
        rot = makexrotform(-95 * pi / 180);
        rect3 = apply_affine_to_rect(rot, rect1')';
        center3 = [rect3(end - 2), rect3(end - 1), rect3(end)];
        rect3(1) = 3;
        %         center3 = [0, ztr, 0];
        %         rect3 = [3, R ztr R, R ztr -R, -R ztr -R, -R ztr R, 1, 2*R, 2*R, center3(1), center3(2), center3(3)];
        %
        %Tx = xdc_rectangles([rect1], [center1], focus);
        Tx = xdc_rectangles([rect1; rect2], [center1; center2], focus);
        %         Tx = xdc_rectangles([rect1; rect2; rect3], [center1; center2; center3], focus);
    case 'pistonfocused'
        %spherical arrays
        switch arraymodel
            case 'Diadem'
                Rcurvature = 120e-3; %m
                dims = 6.5e-3 * numels * [1, 1];
            case 'H-115'
                Rcurvature = 63e-3; %H-115
                dims = 64e-3 * [1, 1];                    
            case 'H-104'
                Rcurvature = 63e-3; %H-104
                dims = 64e-3 * [1, 1];
            case 'H-173'
                Rcurvature = 80e-3; %H-173
                dims = 100e-3 * [1, 1]; %H-173
            case 'H-206'
                Rcurvature = 70e-3; %H-206
                dims = 42e-3 * [1, 1]; %H-206
        end
        Rfocus = Rcurvature;
        %the larger the aperture (either larger dims or larger kerf, the
        %smaller the F#, and so the more the array focuses):
        kerf = 0; %don't need kerf
        %
        allrect = [];
        allcent = [];
        %
        xcordsi = [2, 5, 8, 11, 17]; 
        zcordsi = [4, 7, 10, 13, 19]; %for rectangles
        %first transducer
        [rectangles, cent] = concave_focused_array_rectonly(numels, numels, Rcurvature, kerf, dims / numels, Rfocus);
        %
        translz = 0e-3; %optional translation in z
        rectangles(zcordsi, :) = rectangles(zcordsi, :) + translz;
        cent(3, :) = cent(3, :) + translz;
        %
        allrect = [allrect; rectangles'];
        allcent = [allcent; cent'];
        %
        %2nd, opposing transducer
        rectangles(zcordsi, :) = - rectangles(zcordsi, :);
        rectangles(1, :) = size(allrect, 1) + 1 : size(allrect, 1) + size(rectangles, 2);
        cent(3, :) = -cent(3, :);
        allrect = [allrect; rectangles'];
        allcent = [allcent; cent'];
        %
        %perpendicular transducer
%         xdat = rectangles(xcordsi, :);
%         zdat = rectangles(zcordsi, :);
%         rectangles(xcordsi, :) = -zdat;
%         rectangles(zcordsi, :) = xdat;
%         rectangles(1, :) = size(allrect, 1) + 1 : size(allrect, 1) + size(rectangles, 2);
%         xcent = cent(1, :);
%         zcent = cent(3, :);
%         cent(1, :) = -zcent;
%         cent(3, :) = xcent;
        %         allrect = [allrect; rectangles'];
        %         allcent = [allcent; cent'];
        
        Tx = xdc_rectangles(allrect, allcent, focus);
end


%% Impulse response of a transducer (= acoustic pressure response emitted by a transducer when subjected to an electric dirac driving pulse)
tc = gauspuls('cutoff', f0, fracBW, -3, -40);  %fracBW @ -3dB; cutoff time at -40dB
t = -tc : 1/fs : tc;  %(s) time vector centered about t=0
impulse_response = gauspuls(t,f0,fracBW);
xdc_impulse(Tx, impulse_response);
%
% Plot the impulse response
% plot(t*1e6, impulse_response); grid on; xlabel('t (\musec)');

%% Driving waveform
cycles = 500;
amplitude = 1;
t = (1/fs : (1/fs) : (cycles/f0));
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
        onesegment = amplitude * sin(2*pi*f.*t);
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
switch arraymodel
    case 'Diadem'
        xdc_focus(Tx, 0, focus);
    otherwise %physical array, no electronic focusing
        delays = zeros(1, length(allrect)); %all zeros
        xdc_focus_times(Tx, 0, delays); %all fired at once
end

%% Show the transducer array in 3D
if visualize_transducer
    xdc_show(Tx);  %#ok<UNRCH>
    show_xdc(Tx);
    zlim([-150, 150]);
    view([90, 90, 90]);
    return;
end

%% Set measurement points
switch outputdim
    case 'xy'
        x = (-60 : 0.5 : 60)*1e-3;
        y = (-60 : 0.5 : 60)*1e-3;
%        y = x;
        z = focus(3);
%         z = 60e-3;
    case 'xz'
        x = (-20 : 0.5 : 20)*1e-3;
        y = 0;
        z = (-70 : 0.5 : 40)*1e-3;
    case 'line'
        x = focus(1);
        y = focus(2);
        z = (-55 : 0.1 : 55)*1e-3;
end
%create all individual x, y, z points within the above ranges
[xv, yv, zv] = meshgrid(x, y, z);
pos = [xv(:), yv(:), zv(:)];

%% Calculate the emitted field at those points
[hp, ~] = calc_hp(Tx, pos); %this is where the simulation happens

% txfield = mean(hp.^2, 1); %overall average energy (normalized per time)
%     txfield = mean(abs(hp), 1); %overall average energy (normalized per time)
%     txfield = mean(hp.^2, 1); %overall average energy (normalized per time)
%     txfield = sum(hp.^2, 1); %overall energy (intensity integrated over time)
    txfield = max(hp, [], 1); %max power over time

%% Plot the emitted field
switch outputdim
    case 'xy'
        txfield = reshape(txfield, numel(x), numel(y));
    otherwise
        txfield = reshape(txfield, numel(x), numel(z));
end

% set(gcf,'position', [   1           1        2560        1344]);
set(gcf,'position', [1           1        1680         954]);
if propagationmovie
    set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
    %     hold on;
    txfield = hp;
    for n = 1 : size(hp, 1)
        plot(z, txfield(n, :));
        ylim([-max(max(hp)) +max(max(hp))]);
        pause(0.001);
    end
else
    switch outputdim
        case 'line'
            hold on;
            set(gcf, 'position', [1 1 1680 954]);
            plot(z * 1000, txfield);
            hold on;
            xlabel('z (mm)');
            ylabel('Pressure');
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            env = findenv(z, txfield);
            plot(z * 1000, env, 'k:');
            fwhmv = fwhm(env, z * 1000, false);
            fprintf('FWHM = %.1f mm\n', fwhmv);
        case 'xz'
            imagesc(z*1e3, x*1e3, txfield); colorbar;
            axis equal;
            ylabel('x (mm)');
            xlabel('z (mm)');
            ch = colorbar; ylabel(ch, 'Out');
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
        case 'xy'
            imagesc(x*1e3, y*1e3, txfield); colorbar;
            axis equal;
            ylabel('x (mm)');
            xlabel('y (mm)');
            ch = colorbar; ylabel(ch, 'Out');
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
    end
end


%% Terminate Field II
field_end();


%%-------------
function yout = findenv(x, y)
x = x(:);
y = y(:);
[pks, locs] = findpeaks(abs(y), x, 'MinPeakDist', 1e-3);
%ylin = interp1(locs, pks, x, 'spline');
ylin = interp1(locs, pks, x);
yout = ylin;