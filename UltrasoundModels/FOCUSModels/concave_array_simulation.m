function [txfield, xdc_data]=concave_array_simulation(varargin)

default_element_W = 1.5;
expectedGeometries = {'focused','spherical','flat','focused2','linear'};

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
addOptional(p,'Slice','xy');
parse(p, varargin{:})

% FNM CW CSA Example
width = p.Results.D(1)*1e-3;
height = p.Results.D(2)*1e-3;
elements_x = p.Results.Nx;
elements_y = p.Results.Ny;
kerf = (p.Results.D(2)-p.Results.P)*1e-3;
spacing = width + kerf;
ROC = p.Results.ROC*1e-3;

transducer_array = create_rect_csa(elements_x, elements_y, width, height, kerf, kerf, ROC);
draw_array(transducer_array);

define_media();
f0 = 650e3;  %(Hz) center frequency of the transducer
fs = f0 * 20*2;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
lambda = (lossless.soundspeed / f0);
focus = p.Results.focal_point*1e-3;
focus_x = focus(1); focus_y = focus(2); focus_z = focus(3);

ndiv = round(2 * width/lambda); 

[x,y,z] = get_slice_xyz(p.Results.Slice, focus);
coord_grid = xyz_to_coord_grid(x,y,z);


transducer_array = find_single_focus_phase(transducer_array, focus_x, ...
focus_y, focus_z, water, f0, 200);
% The next step is to run the FNM function and display the resulting
% pressure field.
ndiv=3;
tic();
disp('Calculating pressure field...');
p_cw=cw_pressure(transducer_array, coord_grid, lossless, ndiv, f0);
disp(['Simulation complete in ', num2str(toc()), ' seconds.'])
figure();
h = pcolor(x*1000,z*1000,rot90(squeeze(abs(p_cw)),3));
set(h,'edgecolor','none');
title('Pressure Field at y = 0 cm');
xlabel('x (cm)');
ylabel('z (cm)');

end