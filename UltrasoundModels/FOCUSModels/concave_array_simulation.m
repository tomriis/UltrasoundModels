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

end