function [p_cw, transducer_array]=concave_array_simulation(varargin)

default_element_W = 1.5;
expectedGeometries = {'focused','spherical','flat','focused2','linear'};

p = inputParser;
addRequired(p,'n_elements_x', @(x) isnumeric(x));
addRequired(p,'n_elements_y', @(x) isnumeric(x));
addRequired(p,'ROC', @(x) isnumeric(x));
addRequired(p,'D');
addRequired(p, 'focal_point');
addOptional(p, 'kerf',0.2);

addOptional(p, 'element_geometry', 'flat', @(x) any(validatestring(x,expectedGeometries)));
addOptional(p, 'R_focus', 1e4, @(x) isnumeric(x));

addOptional(p,'visualize_transducer',false);
addOptional(p,'visualize_output',true);
addOptional(p,'Slice','xy');
parse(p, varargin{:})

% FNM CW CSA Example
ROC = p.Results.ROC/1000; %mm
n_elements_x = p.Results.n_elements_x;  %number of physical elements in X.
n_elements_y = p.Results.n_elements_y;  %number of physical elements in Y.
kerf = p.Results.kerf/1000;
D = p.Results.D; %Diameter, width, and length of element (mm)
width = D(1)/1000;
height = D(2)/1000;
element_geometry = p.Results.element_geometry;
R_focus = p.Results.R_focus/1000;
spacing = width + kerf;

transducer_array = create_rect_csa(n_elements_x, n_elements_y, width, height, kerf, kerf, ROC);

define_media();
f0 = 650e3;  %(Hz) center frequency of the transducer
fs = f0 * 20*1.5;  %(Hz) sampling frequency of the simulation; 20 times the transducer frequency is enough
alpha = 0.5 * 100 / 1e6;  %(dB/m/Hz) attenuation of ultrasound in the brain
lambda = (lossless.soundspeed / f0);
focus = p.Results.focal_point*1e-3;
focus_x = focus(1); focus_y = focus(2); focus_z = focus(3);


[x,y,z] = get_slice_xyz(p.Results.Slice, focus);
coord_grid = xyz_to_coord_grid(x,y,z);

%transducer_array = set_time_delays(transducer_array, focus_x,focus_y, focus_z, water, fs);
transducer_array = find_single_focus_phase(transducer_array, focus_x,focus_y, focus_z, water, f0, 200,false);
% The next step is to run the FNM function and display the resulting
% pressure field.
ndiv=3;

ndiv2 = round(2 * width/lambda); 

if ndiv<ndiv2
   ndiv = ndiv2;
end
ndiv=3;
p_cw=cw_pressure(transducer_array, coord_grid, lossless, ndiv, f0);

%figure();
%h = pcolor(x*1000,z*1000,rot90(squeeze(abs(p_cw)),3));
%set(h,'edgecolor','none');
%title('Pressure Field at y = 0 cm');
%xlabel('x (cm)');
%ylabel('z (cm)');

end