h1 = figure;

h = 0.2; xm = (-5:h:5); ym = x; zm = (7.5:h:30);

x = kgrid.x_vec*1000; y = kgrid.y_vec*1000; z = kgrid.z_vec*1000; % meters -> millimeters
z= -1*(z-z_val*1000);
m = 2; n = 4;
planes= {'XY','XZ','YZ'};
z_mask = and(z>=7.5, z <= 30);
x_mask = and(x<max(xm), x>min(xm));
y_mask = and(y<max(ym), y>min(ym));


load('C:\Users\Tom\Documents\MATLAB\UltrasoundModels\UltrasoundModels\FieldIIModels\xdr_testing\2DScansNoMatchingLayer1.mat');
load('C:\Users\Tom\Documents\MATLAB\UltrasoundModels\UltrasoundModels\FieldIIModels\xdr_testing\WaveformsMatchingLayer2.mat');
xy = abs(xy)/cal*1e-6; yz = abs(yz)/cal*1e-6; xz = abs(xz)/cal*1e-6;



for i = 1:3
    switch planes{i}
        case 'XY'
            subplot(m,n,1);
            [~, z_point] = min( abs(10 - z));
            imagesc(y(y_mask),x(x_mask),data(x_mask,y_mask,z_point));
            xl = 'X (mm)'; yl = 'Y (mm)';
            loaded_field = xy;
            xx = xm; yy = ym;
        case 'XZ'
            subplot(m,n,2);
            [~, y_point] = min(abs(0.0 - y));
            imagesc(z(z_mask),x(x_mask), squeeze(data(x_mask,y_point,z_mask)));
            xl = 'X (mm)'; yl = 'Z (mm)';
            loaded_field = xz;
            xx = xm; yy = zm;
        case 'YZ'
            subplot(m,n,3);
            [~, x_point] = min(abs(0.0 - x));
            imagesc(z(z_mask),y(y_mask), squeeze(data(x_point,y_mask,z_mask)));
            xl = 'Y (mm)'; yl = 'Z (mm)';
            loaded_field = yz;
            xx = ym; yy = zm;
    end
    maxC = max([max(data(x_mask,y_mask, z_mask),[],'all'), max(xy), max(yz), max(xz)]);
    title(['Simulated PNP in ', planes{i},' Plane']); 
    xlabel(xl);
    ylabel(yl);
    colormap('hot');
    caxis([0 maxC]);
    colorbar;
    axis equal tight
    
    subplot(m,n,i+n);
    imagesc(yy, xx, loaded_field');
    title(['Measured PNP in ', planes{i},' Plane']); 
    xlabel(xl);
    ylabel(yl);
    colormap('hot');
    caxis([0 maxC]);
    colorbar;
    axis equal tight
end

subplot(m,n,4);
[~, z_focus] = min(abs(7.5-z));
plot(kgrid.t_array*1e6, squeeze(data_t(x_point, y_point, z_focus, :)),...,
    'DisplayName', 'Simulated'); hold on;
plot(t, wv100/cal*1e-6,'DisplayName', 'Measured');
legend;
xlabel('Time (us)');
ylabel('Pressure (Mpa)');
title('Waveform: With Matching Layer');

subplot(m,n,8);
plot(z(z_mask), squeeze(data(x_point, y_point,z_mask)),'DisplayName', 'Simulated'); hold on;
plot(zm,abs(yz(1:length(zm),25)),'DisplayName','Measured');
legend;
xlabel('Z (mm)');
ylabel('Pressure (Mpa)');
title('Amplitude vs Distance From XDR');

set(h1,'color','w');