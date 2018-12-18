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
width = 1e-3;
height = 5e-3;
elements_x = 64;
elements_y = 1;
kerf = 4e-4;
spacing = width + kerf;
r_curv = (elements_x*spacing)/pi;
transducer_array = create_rect_csa(elements_x, elements_y, width, height,...
kerf, kerf, r_curv);
draw_array(transducer_array);
% This sets up a cylindrical section transducer array with 20 0.7 mm x 3 mm
% elements spaced 0.5 mm edge-to-edge.
define_media();
f0 = 1e6;
lambda = (lossless.soundspeed / f0);
xmin = -1.2 * r_curv;
xmax = 1.2 * r_curv;
ymin = 0;
ymax = 0;
zmin = r_curv; % Don't capture the pressure field inside the transducer array
zmax = 40 * lambda;
focus_x = 0;
focus_y = 0;
focus_z = 30 * lambda;
xpoints = 400;
ypoints = 1;
zpoints = 300;
dx = (xmax-xmin)/xpoints;
dy = (ymax-ymin)/ypoints;
dz = (zmax-zmin)/zpoints;
x = xmin:dx:xmax;
y = ymin:dy:ymax;
z = zmin:dz:zmax;
delta = [dx dy dz];
coord_grid = set_coordinate_grid(delta, xmin, xmax, ymin, ymax, zmin, zmax);

end